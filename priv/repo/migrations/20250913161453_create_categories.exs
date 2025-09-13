defmodule Hyperion.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string
      add :category_id, :integer
    end
  end
end
