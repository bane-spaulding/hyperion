defmodule Hyperion.ViewTracker do
  use GenServer

  require Logger
  import Ecto.Query, warn: false
  alias Hyperion.Repo

  alias Hyperion.Repo.{Secret, Video}

  @api_url "https://youtube.googleapis.com/youtube/v3/videos"
  @request_timeout 15000

  # Client-facing API functions
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def get_views(video_id) do
    GenServer.call(__MODULE__, {:get_views, video_id}, @request_timeout)
  end

  # GenServer callbacks
  @impl true
  def init(initial_state) do
    # This function is called when the worker process starts
    # It initializes the worker's internal state.
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:get_views, video_id}, _from, state) do
    Logger.info("YouTube Worker is getting views for: #{inspect(video_id)}")

    result = case Repo.get(Secret, 1) do
      %Secret{access_token: access_token} ->
        params = %{
          "part" => "statistics",
          "id" => video_id
        }

        with {:ok, resp} <- [url: @api_url, params: params]
          |> Req.new()
          |> Req.Request.put_header("Authorization", "Bearer #{access_token}")
          |> Req.get() do
            case resp.status do
              200 ->
                Logger.info("Successfully fetched views for #{video_id}.")
                Logger.debug(resp.body)

                %{"items" => items} = resp.body

                videos = Enum.map(items, fn map ->
                  convert_to_video(map)
                end)

                Task.start(fn -> save_videos(videos) end)

                {:ok, videos}
              404 ->
                {:error, :not_found}
              status ->
                {:error, {:unexpected_status, status}}
            end
        else
          {:error, reason} ->
            {:error, {:request_failed, reason}}
        end
      nil ->
        {:stop, "No existing access_token found, impossible condition, halting system."}
    end

    {:reply, result, state}
  end

  defp save_videos(videos) do
    inserted_at = DateTime.utc_now()
      |> DateTime.truncate(:second)

    videos_attrs =
      Enum.map(videos, fn video ->
        video
        |> Map.from_struct()
        |> Map.drop([:__meta__, :id]) # remove Ecto metadata and primary key
        |> Map.put(:inserted_at, inserted_at)
        |> Map.put(:updated_at, inserted_at)
      end)

    case Repo.insert_all(Video, videos_attrs) do
      {0, nil} ->
        Logger.error("Failed to save videos.")
      {count, _} ->
        Logger.info("Successfully inserted #{count} videos.")
    end
  end

  defp convert_to_video(map) do
    %{
      "etag" => etag,
      "id" => id,
      "kind" => kind,
      "statistics" => %{
        "commentCount" => comment_count,
        "dislikeCount" => dislike_count,
        "favoriteCount" => favorite_count,
        "likeCount" => like_count,
        "viewCount" => view_count
      }
    } = map

    %Video{
      etag: etag,
      video_id: id,
      kind: kind,
      view_count: String.to_integer(view_count),
      like_count: String.to_integer(like_count),
      dislike_count: String.to_integer(dislike_count),
      favorite_count: String.to_integer(favorite_count),
      comment_count: String.to_integer(comment_count)
    }
  end
end
