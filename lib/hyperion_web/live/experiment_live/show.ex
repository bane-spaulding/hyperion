defmodule HyperionWeb.ExperimentLive.Show do
  use HyperionWeb, :live_view

  alias Hyperion.Experiments
  alias Hyperion.Videos.Thumbnails

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Experiment {@experiment.id}
        <:subtitle>This is a experiment record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/experiments"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/experiments/#{@experiment}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit experiment
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Channel">{@experiment.channel_id}</:item>
        <:item title="Video">{@experiment.video_id}</:item>
        <:item title="Title">{@experiment.title}</:item>
        <:item title="Thumbnail">{@experiment.thumbnail.file_id}</:item>

      </.list>
      <img src={~p"/thumbnails/#{@experiment.thumbnail.id}"} class="w-full object-cover rounded-xl shadow-xl border-4 border-white" />
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Experiment")
     |> assign(:experiment, Experiments.get_experiment!(id))}
  end
end
