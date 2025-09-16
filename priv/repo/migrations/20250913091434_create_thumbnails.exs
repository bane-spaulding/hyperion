defmodule Hyperion.Repo.Migrations.CreateThumbnails do
  use Ecto.Migration

  def change do
    create table(:thumbnails, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :file_id, :string, null: false
      add :data, :binary, null: false
      add :content_type, :string, null: false
      add :channel_id, :string

      add :experiment_id, references(:experiments, type: :binary_id, on_delete: :delete_all)


      timestamps(type: :utc_datetime)
    end

    create index(:thumbnails, [:experiment_id])
  end
end
