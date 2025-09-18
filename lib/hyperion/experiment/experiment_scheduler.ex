defmodule Hyperion.Experiment.ExperimentScheduler do
  use GenServer

  require Logger
  import Ecto.Query, warn: false

  alias Hyperion.Repo
  alias Hyperion.Experiments
  alias Hyperion.ExperimentRuns
  alias Hyperion.Experiments.ExperimentWorker
  alias Hyperion.ViewTracker
  alias Hyperion.Videos


  @views_topic "views_1m"

  @schedule_timeout_min 30
  @schedule_interval :timer.minutes(1)

  @persist_interval :timer.minutes(15)

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Logger.info("Subscribing to existing topic: #{@views_topic}.")
    Phoenix.PubSub.subscribe(Hyperion.PubSub, @views_topic)
    Logger.info("Starting ExperimentScheduler.")
    Process.send_after(self(), :schedule, 100)
    {:ok, %{}}
  end

  @impl true
  def handle_info(:schedule, state) do
    Logger.info("ExperimentScheduler is looking for new experiments to schedule.")

    active_experiments = Experiments.list_active_experiments()

    Enum.each(active_experiments, fn exp ->
      start_ts = DateTime.utc_now()

      case Experiments.get_active_experiment_with_run() do
        nil ->
          {:stop, :experiment_not_found}

        %Experiment{experiment_run: %{allocation_strategy: strategy}} = exp ->
          Logger.info("Using allocation strategy for experiment #{exp.id}: #{inspect(strategy)}")
          run_attrs = %{
            campaign_id: exp.campaign_id,
            experiment_id: exp.id,
            run_number: next_run_number(exp.campaign_id),
            status: :scheduled,
            start_ts: start_ts,
            end_ts: DateTime.add(start_ts, @schedule_timeout_min, :minute),
            schedule_window: to_string("#{@schedule_timeout_min}m"),
            allocation_strategy: strategy || %{"type" => "equal"},
            view_count: 0
          }

          case ExperimentRuns.create_experiment_run(run_attrs) do
            {:ok, run} ->
              Logger.info("Created new experiment run with ID: #{run.id}")
              {:ok, _pid} = ExperimentWorker.start_link(exp.id)
              Logger.info("Launched ExperimentWorker for experiment ID: #{exp.id}")

            {:error, changeset} ->
              Logger.error("Failed to create experiment run for experiment #{exp.id}: #{inspect(changeset.errors)}")
          end

        %Experiment{} ->
          Logger.warn("Experiment #{exp.id} is active but has no associated run.")
          {:stop, :no_active_run}
      end
    end)

    video_ids = active_experiments |> Enum.map(& &1.video_id) |> Enum.join(",")
    GenServer.cast(Hyperion.ViewTracker, {:request, %{video_ids: video_ids}})
    Logger.info("Sent a view tracking request for video IDs: #{video_ids}")

    Process.send_after(self(), :schedule, @schedule_interval)
    {:noreply, state}
  end

  @impl true
  def handle_info({:view_stats, stats_map}, state) do
    Enum.each(stats_map, fn {video_id, view_count} ->
      case Experiments.get_active_experiment_by_video_id(video_id) do
        nil ->
          Logger.warn("No active experiment found for video ID #{video_id}")

        %Experiment{experiment_run: %ExperimentRun{} = run} ->
          start_view_count = Videos.get_views_closest_to_timestamp(video_id, run.start_ts)
          update_run_view_count(run, view_count - start_view_count)

        %Experiment{} ->
          Logger.warn("Experiment for video ID #{video_id} has no associated experiment run")
      end
    end)

    {:noreply, state}
  end

  defp update_run_view_count(run, view_count) do
    case ExperimentRuns.update_experiment_run(run, %{view_count: view_count}) do
      {:ok, _updated_run} ->
        Logger.info("Updated view count for experiment_run #{run.id}: #{view_count}")

      {:error, changeset} ->
        Logger.error("Failed to update experiment_run #{run.id}: #{inspect(changeset.errors)}")
    end
  end

  defp next_run_number(campaign_id) do
    Repo.one(
      from er in ExperimentRun,
        where: er.campaign_id == ^campaign_id,
        select: max(er.run_number)
    ) || 0
    |> Kernel.+(1)
  end
end
