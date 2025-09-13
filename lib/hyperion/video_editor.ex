defmodule Hyperion.VideoEditor do
  use GenServer

  require Logger

  alias Hyperion.Repo
  alias Hyperion.Repo.Secret
  alias Hyperion.Titles

  @api_title_url "https://www.googleapis.com/youtube/v3/videos"
  @title_max_length 100
  # @api_thumbnail_url "https://www.googleapis.com/upload/youtube/v3/thumbnails/set"
  # @thumbnail_accepted_types ["image/jpeg","image/png","application/octet-stream"]
  # @thumbnail_max_bytes_size 2000000

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  def set_title(video_id, category_id, title) do
    GenServer.call(__MODULE__, {:set_title, video_id, category_id, title})
  end

  @impl true
  def handle_call({:set_title, video_id, category_id, title}, _from, state) do
    if String.length(title) > @title_max_length do
      {:reply, {:error, :title_too_long}, state}
    else
      case update_video_title(video_id, category_id, title) do
        {:ok, _resp} ->
          {:reply, {:ok, :title_updated}, state}

        {:error, reason} ->
          {:reply, {:error, reason}, state}
      end
    end
  end

  defp update_video_title(video_id, category_id, title) do
    with %Secret{access_token: access_token} <- Repo.get(Secret, 1),
         headers = [
           {"Authorization", "Bearer #{access_token}"},
           {"Content-Type", "application/json"}
         ],
         snippet = %{title: title, categoryId: category_id},
         body = %{id: video_id, snippet: snippet},
         encoded_body = Jason.encode!(body),
         {:ok, resp} <-
           Req.put(
             @api_title_url,
             headers: headers,
             params: %{part: "snippet"},
             body: encoded_body
           ) do
      handle_api_response(resp, video_id, category_id, title)
    else
      nil ->
        {:error, :token_not_found}

      _ ->
        {:error, :unknown_error}
    end
  end

  defp handle_api_response(%{status: 200}, video_id, category_id, title) do
    video_title = %{title: title, category_id: category_id, video_id: video_id}
    case Titles.get_by(video_title) do
      nil ->
        Logger.debug("Saving to DB for video: #{video_id} - new title #{inspect(video_title)}")
        case Titles.create_title(video_title) do
          {:ok, _title} ->
            Logger.debug("Successfully saved new title to database.")
            {:ok, :title_updated}
          {:error, changeset} ->
            Logger.error("Failed to save new title: #{inspect(changeset.errors)}")
            {:error, :db_error}
        end


      _ ->
        Logger.debug("Title already exists on Database")
    end
    {:ok, :title_updated}
  end

  defp handle_api_response(resp, video_id, _category_id, _title) do
    Logger.error("Failed to update title for video: #{video_id}. Response: #{inspect(resp)}")
    {:error, :api_error}
  end

  @impl true
  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
