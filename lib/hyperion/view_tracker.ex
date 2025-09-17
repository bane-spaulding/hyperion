defmodule Hyperion.ViewTracker do
  use GenServer

  require Logger
  import Ecto.Query, warn: false

  alias Hyperion.Repo
  alias Hyperion.Repo.{Secret, Video}
  alias Hyperion.Videos

  @api_url "https://youtube.googleapis.com/youtube/v3/videos"
  # @request_interval :timer.seconds(15)
  @request_interval :timer.minutes(1)
  @topic "views_1m"

  # Client-facing API functions
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # GenServer callbacks
  @impl true
  def init(video_ids) do
    state = %{
      video_ids: video_ids
    }

    Kernel.send(self(), :request)
    {:ok, state}
  end

  @impl true
  def handle_info(:request, %{video_ids: video_id_string} = state) do
    Logger.info("YouTube Worker is getting views for: #{inspect(video_id_string)}")

    video_ids = String.split(video_id_string, ",")
    last_view_counts = Videos.get_last_view_counts(video_ids)

    case Repo.get(Secret, 1) do
      %Secret{access_token: access_token} ->
        params = %{
          "part" => "statistics",
          "id" => video_id_string
        }

        with {:ok, resp} <-
               [url: @api_url, params: params]
               |> Req.new()
               |> Req.Request.put_header("Authorization", "Bearer #{access_token}")
               |> Req.get() do
          case resp.status do
            200 ->
              Logger.info("Successfully fetched views for #{video_ids}.")
              Logger.debug(resp.body)

              %{"items" => items} = resp.body

              videos = process_videos(items, last_view_counts)

              Task.start(fn -> save_videos(videos) end)
              Phoenix.PubSub.broadcast(Hyperion.PubSub, @topic, {:videos, videos})

              Process.send_after(self(), :request, @request_interval)
              {:noreply, state}

            404 ->
              {:stop, :not_found, video_id_string}

            status ->
              Logger.debug(resp.body)
              {:stop, :unexpected_status, status}
          end
        else
          {:error, reason} ->
            {:stop, :request_failed, reason}
        end

      nil ->
        {:stop, "No existing access_token found, impossible condition, halting system.", video_ids}
    end
  end

    defp process_videos(items, last_view_counts) do
    Enum.map(items, fn map ->
      %Video{
        etag: map["etag"],
        video_id: map["id"],
        kind: map["kind"],
        view_count: String.to_integer(map["statistics"]["viewCount"]),
        like_count: String.to_integer(map["statistics"]["likeCount"]),
        dislike_count: String.to_integer(Map.get(map["statistics"], "dislikeCount", "0")),
        favorite_count: String.to_integer(map["statistics"]["favoriteCount"]),
        comment_count: String.to_integer(map["statistics"]["commentCount"]),
        view_change: String.to_integer(map["statistics"]["viewCount"]) - Map.get(last_view_counts, map["id"], 0)
      }
    end)
  end

  defp save_videos(videos) do
    inserted_at =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    videos_attrs =
      Enum.map(videos, fn video ->
        video
        |> Map.from_struct()
        |> Map.drop([:__meta__, :id])
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
end
