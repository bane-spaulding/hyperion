defmodule Hyperion.Strategies.StrategyManager do
  use GenServer

  require Logger
  alias Hyperion.Repo
  alias Hyperion.Repo.{Strategy, ExperimentRun}

  import Ecto.Query

  @check_interval :timer.seconds(30)

  @strategy_length_days 12
  @strategy_duration :timer.hours(24*@strategy_length_days)

  def start_link(strategy_id) when is_binary(strategy_id) do
    GenServer.start_link(__MODULE__, strategy_id, name: {:global, {:strategy_manager, strategy_id}})
  end

  @impl true
  def init(strategy_id) do
    Logger.info("Starting StrategyManager for strategy ID: #{strategy_id}")
    strategy = Repo.get!(Strategy, strategy_id)
    start_time = DateTime.utc_now()

    Process.send_after(self(), :check_status, @check_interval)

    state = %{
      strategy: strategy,
      start_time: start_time
    }

    {:ok, state}
  end

  @impl true
  def handle_info(:check_status, %{strategy: strategy, start_time: start_time} = state) do
    current_time = DateTime.utc_now()

    if DateTime.diff(current_time, start_time, :second) >= @strategy_duration do
      Logger.info("Strategy #{strategy.id} has ended. Picking the winner.")

       highest_views =
        from(er in ExperimentRun,
          where: er.strategy_id == ^strategy.id,
          order_by: [desc: er.view_count],
          limit: 1
        )
        |> Repo.one()


      winner = if highest_views, do: highest_views.experiment_id, else: nil

      Repo.update!(%Strategy{
        strategy
        | status: :completed,
          end_ts: current_time,
          winner_experiment_id: winner
      })

      Logger.info("Strategy #{strategy.id} finished. Winner is: #{inspect(winner)}")

      {:stop, :normal, state}
    else
      Logger.info("Strategy #{strategy.id} is still active. Rescheduling status check.")
      Process.send_after(self(), :check_status, @check_interval)
      {:noreply, state}
    end
  end

  @impl true
  def terminate(reason, %{strategy: strategy}) do
    Logger.info("Strategy manager for #{strategy.id} terminating with reason: #{inspect(reason)}")
    :ok
  end
end
