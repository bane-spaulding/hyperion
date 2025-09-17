defmodule Hyperion.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :video_id, :string, null: false
      add :etag, :string
      add :kind, :string
      add :view_count, :integer, null: false
      add :view_change, :integer, null: false
      add :like_count, :integer
      add :dislike_count, :integer
      add :favorite_count, :integer
      add :comment_count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
