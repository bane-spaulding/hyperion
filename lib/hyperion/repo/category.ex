defmodule Hyperion.Repo.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string
    field :category_id, :integer
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title, :category_id])
    |> validate_required([:title, :category_id])
  end
end
