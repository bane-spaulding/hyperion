defmodule Hyperion.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :channel_id, :string, null: false
      add :video_id, :string, null: false
      add :title, :string, null: false
      add :views, :integer, default: 0
      add :category_id, :integer, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
