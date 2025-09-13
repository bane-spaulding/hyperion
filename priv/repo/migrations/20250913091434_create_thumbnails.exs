defmodule Hyperion.Repo.Migrations.CreateThumbnails do
  use Ecto.Migration

  def change do
    create table(:thumbnails) do
      add :data, :binary
      add :content_type, :string
      add :channel_id, :string
      add :video_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
