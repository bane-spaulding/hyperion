defmodule HyperionWeb.StrategyLive.Show do
  use HyperionWeb, :live_view

  alias Hyperion.Strategies

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Strategy {@strategy.id}
        <:subtitle>This is a strategy record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/strategies"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/strategies/#{@strategy}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit strategy
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@strategy.name}</:item>
        <:item title="Description">{@strategy.description}</:item>
        <:item title="Status">{@strategy.status}</:item>
        <:item title="Start ts">{@strategy.start_ts}</:item>
        <:item title="End ts">{@strategy.end_ts}</:item>
        <:item title="Schedule">{@strategy.schedule}</:item>
        <:item title="Winner experiment">{@strategy.winner_experiment_id}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Strategy")
     |> assign(:strategy, Strategies.get_strategy!(id))}
  end
end
