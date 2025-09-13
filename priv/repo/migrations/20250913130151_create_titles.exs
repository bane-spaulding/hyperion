defmodule Hyperion.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles) do
      add :title, :string
      add :video_id, :string
      add :category_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
