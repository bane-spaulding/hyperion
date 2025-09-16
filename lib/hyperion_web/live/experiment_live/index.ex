defmodule HyperionWeb.ExperimentLive.Index do
  use HyperionWeb, :live_view

  alias Hyperion.Experiments
  alias Hyperion.Videos.Thumbnails

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="px-4 sm:px-6 lg:px-8 w-full">
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
        class="table-fixed w-full"
      >
        <:col :let={{_id, experiment}} label="Thumbnail"  class="w-42">
          <%= if experiment.thumbnail do %>
            <img src={experiment.thumbnail} class="w-40 h-24 object-cover rounded" />
          <% else %>
            <span class="text-gray-400">No Image</span>
          <% end %>
        </:col>
        <:col :let={{_id, experiment}} label="Title" class="w-24">{experiment.title}</:col>
        <:col :let={{_id, experiment}} label="Video" class="w-24">
            <a href={"https://www.youtube.com/watch?v=#{experiment.video_id}"} target="_blank" class="text-blue-600 hover:text-blue-800">
    {experiment.video_id}
            </a>
        </:col>
        <:col :let={{_id, experiment}} label="Channel" class="w-24">
            <a href={"https://www.youtube.com/channel/#{experiment.channel_id}"} target="_blank" class="text-blue-600 hover:text-blue-800">
    {experiment.channel_id}
            </a>

        </:col>

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
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Experiments")
     |> stream(:experiments, prepare_experiments())}
  end

  defp prepare_experiments do
    Experiments.list_experiments()
    |> Enum.map(fn experiment ->
      thumbnail = if experiment.thumbnail.id do
        case Thumbnails.get_thumbnail!(experiment.thumbnail.id) do
          nil -> nil
          %{data: data} ->
            "data:image/jpeg;base64," <> Base.encode64(data)
        end
      else
        nil
      end
      Map.put(experiment, :thumbnail, thumbnail)
    end)
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
