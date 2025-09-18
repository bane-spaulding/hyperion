defmodule Hyperion.Experiments.ExperimentWorker do
  use GenServer

  require Logger

  alias Hyperion.Experiments
  alias Hyperion.VideoEditor
  alias Hyperion.Videos.Thumbnails

  @check_interval :timer.minutes(1)
  @experiment_duration :timer.minutes(30)

  def start_link(experiment_id) when is_binary(experiment_id) do
    GenServer.start_link(__MODULE__, experiment_id, name: {:global, {:experiment_worker, experiment_id}})
  end

  @impl true
  def init(experiment_id) do
    Logger.info("Starting experiment worker for ID: #{experiment_id}")
    experiment = Experiments.get_experiment!(experiment_id)
    start_time = DateTime.utc_now()

    thumbnail =
      case experiment.thumbnail_id do
        nil ->
          nil
        id ->
          Thumbnails.get_thumbnail!(id)
      end

    Logger.info("Applying changes to video #{experiment.video_id}...")
    case VideoEditor.set_title(experiment.video_id, experiment.category_id, experiment.title) do
      {:ok, _} -> Logger.info("Video title updated.")
      {:error, reason} -> Logger.error("Failed to update video title: #{inspect(reason)}")
    end

    if thumbnail do
      case VideoEditor.set_thumbnail(experiment.video_id, thumbnail) do
        {:ok, _} -> Logger.info("Video thumbnail updated.")
        {:error, reason} -> Logger.error("Failed to update video thumbnail: #{inspect(reason)}")
      end
    end

    Process.send_after(self(), :check_status, @check_interval)

    state = %{
      experiment: experiment,
      start_time: start_time
    }

    {:ok, state}
  end

  @impl true
  def handle_info(:check_status, %{experiment: experiment, start_time: start_time} = state) do
    Logger.info("Checking status for experiment: #{experiment.id}")

    current_time = DateTime.utc_now()

    if DateTime.diff(current_time, start_time, :second) >= @experiment_duration do
      Logger.info("Experiment #{experiment.id} has ended. Shutting down worker.")
      {:stop, :normal, state}
    else
      Logger.info("Experiment #{experiment.id} is still active. Rescheduling check.")
      Process.send_after(self(), :check_status, @check_interval)
      {:noreply, state}
    end
  end

  @impl true
  def terminate(reason, %{experiment: experiment}) do
    Logger.info("Experiment worker for #{experiment.id} terminating with reason: #{inspect(reason)}")
    {:ok, Experiments.update_experiment(experiment, %{is_active: false})}
  end
end
