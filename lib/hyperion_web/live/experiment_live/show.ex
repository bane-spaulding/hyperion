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

      <div class="flex gap-4 items-start">
  <div class="flex-shrink-0">
    <img src={~p"/thumbnails/#{@experiment.thumbnail.id}"} class="w-140 object-cover rounded-xl shadow-xl border-4 border-white" />
  </div>
  <div class="min-w-0">
    <.list>
      <:item title="Title">{@experiment.title}</:item>
      <:item title="Thumbnail">{@experiment.thumbnail.file_id}</:item>
      <:item title="Video">
        <a href={"https://www.youtube.com/watch?v=#{@experiment.video_id}"} target="_blank" class="text-blue-600 hover:text-blue-800">
          {@experiment.video_id}
        </a>
      </:item>
      <:item title="Channel">
        <a href={"https://www.youtube.com/channel/#{@experiment.channel_id}"} target="_blank" class="text-blue-600 hover:text-blue-800">
          {@experiment.channel_id}
        </a>
      </:item>
    </.list>
  </div>
</div>
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
