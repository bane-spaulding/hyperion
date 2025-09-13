defmodule Hyperion.Repo.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :video_id,
             :etag,
             :kind,
             :view_count,
             :like_count,
             :dislike_count,
             :favorite_count,
             :comment_count,
             :inserted_at,
             :updated_at
           ]}

  schema "videos" do
    field :etag, :string
    field :video_id, :string
    field :kind, :string
    field :view_count, :integer
    field :like_count, :integer
    field :dislike_count, :integer
    field :favorite_count, :integer
    field :comment_count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [
      :etag,
      :video_id,
      :kind,
      :view_count,
      :like_count,
      :dislike_count,
      :favorite_count,
      :comment_count
    ])
    |> validate_required([
      :etag,
      :video_id,
      :kind,
      :view_count,
      :like_count,
      :dislike_count,
      :favorite_count,
      :comment_count
    ])
  end
end
