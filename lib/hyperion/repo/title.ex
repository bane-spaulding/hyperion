defmodule Hyperion.Repo.Title do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :title,
             :video_id,
             :category_id
           ]}
  schema "titles" do
    field :title, :string
    field :video_id, :string
    field :category_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:title, :video_id, :category_id])
    |> validate_required([:title, :video_id,:category_id])
  end
end
