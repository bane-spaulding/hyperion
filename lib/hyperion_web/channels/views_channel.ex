defmodule HyperionWeb.ViewsChannel do
  use Phoenix.Channel

  @topic "views_1m"

  def join(@topic, _message, socket) do
    :ok = Phoenix.PubSub.subscribe(Hyperion.PubSub, @topic)
    {:ok, socket}
  end

  def handle_info({:videos, videos}, socket) do
    push(socket, "videos_updated", %{videos: videos})

    {:noreply, socket}
  end
end
