defmodule Hyperion.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :status, :string, null: false
      add :start_ts, :utc_datetime, null: false
      add :end_ts, :utc_datetime, null: false
      add :schedule, :string

      timestamps(type: :utc_datetime)
    end

    create index(:campaigns, [:status])
  end
end
