defmodule HyperionWeb.ExperimentLive.Index do
  use HyperionWeb, :live_view

  alias Hyperion.Experiments

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Experiments
        <:actions>
          <.button variant="primary" navigate={~p"/experiments/new"}>
            <.icon name="hero-plus" /> New Experiment
          </.button>
        </:actions>
      </.header>

      <.table
        id="experiments"
        rows={@streams.experiments}
        row_click={fn {_id, experiment} -> JS.navigate(~p"/experiments/#{experiment}") end}
      >
        <:col :let={{_id, experiment}} label="Channel">{experiment.channel_id}</:col>
        <:col :let={{_id, experiment}} label="Video">{experiment.video_id}</:col>
        <:col :let={{_id, experiment}} label="Title">{experiment.title}</:col>
        <:col :let={{_id, experiment}} label="Views">{experiment.views}</:col>
        <:col :let={{_id, experiment}} label="Thumbnail">{experiment.thumbnail_id}</:col>
        <:action :let={{_id, experiment}}>
          <div class="sr-only">
            <.link navigate={~p"/experiments/#{experiment}"}>Show</.link>
          </div>
          <.link navigate={~p"/experiments/#{experiment}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, experiment}}>
          <.link
            phx-click={JS.push("delete", value: %{id: experiment.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Experiments")
     |> stream(:experiments, list_experiments())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    experiment = Experiments.get_experiment!(id)
    {:ok, _} = Experiments.delete_experiment(experiment)

    {:noreply, stream_delete(socket, :experiments, experiment)}
  end

  defp list_experiments() do
    Experiments.list_experiments()
  end
end
