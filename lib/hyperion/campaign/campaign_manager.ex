defmodule Hyperion.Campaigns.CampaignManager do
  use GenServer

  require Logger
  alias Hyperion.Repo
  alias Hyperion.Repo.{Campaign, ExperimentRun}

  import Ecto.Query

  @check_interval :timer.seconds(30)

  @campaign_length_days 12
  @campaign_duration :timer.hours(24*@campaign_length_days)

  def start_link(campaign_id) when is_binary(campaign_id) do
    GenServer.start_link(__MODULE__, campaign_id, name: {:global, {:campaign_manager, campaign_id}})
  end

  @impl true
  def init(campaign_id) do
    Logger.info("Starting CampaignManager for campaign ID: #{campaign_id}")
    campaign = Repo.get!(Campaign, campaign_id)
    start_time = DateTime.utc_now()

    Process.send_after(self(), :check_status, @check_interval)

    state = %{
      campaign: campaign,
      start_time: start_time
    }

    {:ok, state}
  end

  @impl true
  def handle_info(:check_status, %{campaign: campaign, start_time: start_time} = state) do
    current_time = DateTime.utc_now()

    if DateTime.diff(current_time, start_time, :second) >= @campaign_duration do
      Logger.info("Campaign #{campaign.id} has ended. Picking the winner.")

       highest_views =
        from(er in ExperimentRun,
          where: er.campaign_id == ^campaign.id,
          order_by: [desc: er.view_count],
          limit: 1
        )
        |> Repo.one()


      winner = if highest_views, do: highest_views.experiment_id, else: nil

      Repo.update!(%Campaign{
        campaign
        | status: :completed,
          end_ts: current_time,
          winner_experiment_id: winner
      })

      Logger.info("Campaign #{campaign.id} finished. Winner is: #{inspect(winner)}")

      {:stop, :normal, state}
    else
      Logger.info("Campaign #{campaign.id} is still active. Rescheduling status check.")
      Process.send_after(self(), :check_status, @check_interval)
      {:noreply, state}
    end
  end

  @impl true
  def terminate(reason, %{campaign: campaign}) do
    Logger.info("Campaign manager for #{campaign.id} terminating with reason: #{inspect(reason)}")
    :ok
  end
end
