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
      add :is_active, :boolean, default: false

      add :campaign_id, references(:campaigns, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
