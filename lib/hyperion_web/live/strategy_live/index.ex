defmodule HyperionWeb.StrategyLive.Index do
  use HyperionWeb, :live_view

  alias Hyperion.Strategies

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Strategies
        <:actions>
          <.button variant="primary" navigate={~p"/strategies/new"}>
            <.icon name="hero-plus" /> New Strategy
          </.button>
        </:actions>
      </.header>

      <.table
        id="strategies"
        rows={@streams.strategies}
        row_click={fn {_id, strategy} -> JS.navigate(~p"/strategies/#{strategy}") end}
      >
        <:col :let={{_id, strategy}} label="Name">{strategy.name}</:col>
        <:col :let={{_id, strategy}} label="Description">{strategy.description}</:col>
        <:col :let={{_id, strategy}} label="Status">{strategy.status}</:col>
        <:col :let={{_id, strategy}} label="Start ts">{strategy.start_ts}</:col>
        <:col :let={{_id, strategy}} label="End ts">{strategy.end_ts}</:col>
        <:col :let={{_id, strategy}} label="Schedule">{strategy.schedule}</:col>
        <:col :let={{_id, strategy}} label="Winner experiment">{strategy.winner_experiment_id}</:col>
        <:action :let={{_id, strategy}}>
          <div class="sr-only">
            <.link navigate={~p"/strategies/#{strategy}"}>Show</.link>
          </div>
          <.link navigate={~p"/strategies/#{strategy}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, strategy}}>
          <.link
            phx-click={JS.push("delete", value: %{id: strategy.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Strategies")
     |> stream(:strategies, list_strategies())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    strategy = Strategies.get_strategy!(id)
    {:ok, _} = Strategies.delete_strategy(strategy)

    {:noreply, stream_delete(socket, :strategies, strategy)}
  end

  defp list_strategies() do
    Strategies.list_strategies()
  end
end
