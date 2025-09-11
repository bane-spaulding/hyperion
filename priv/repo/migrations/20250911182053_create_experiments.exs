defmodule Hyperion.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments) do
      add :title, :string
      add :thumbnail, :string
      add :views, :integer
      add :clicks, :integer
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
