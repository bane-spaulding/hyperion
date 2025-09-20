defmodule Hyperion.Repo.Migrations.CreateStrategies do
  use Ecto.Migration

  def change do
    create table(:strategies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :status, :string, null: false
      add :start_ts, :utc_datetime, null: false
      add :end_ts, :utc_datetime, null: false
      add :schedule, :string, null: false
      add :winner_experiment_id, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:strategies, [:status])
  end
end
