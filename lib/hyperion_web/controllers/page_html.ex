defmodule HyperionWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use HyperionWeb, :html
  use Phoenix.LiveView

  embed_templates "page_html/*"

  @impl true
  def handle_event("go-to-liveview", _params, socket) do
    {:noreply, push_redirect(socket, to: Routes.live_path(socket, HyperionWeb.UploadLive))}
  end
end
