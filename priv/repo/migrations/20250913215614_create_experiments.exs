defmodule Hyperion.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments) do
      add :channel_id, :string
      add :video_id, :string
      add :title, :string
      add :views, :integer, default:0
      add :thumbnail_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
