defmodule Hyperion.Repo.Experiment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Hyperion.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "experiments" do
    field :title, :string
    field :video_id, :string
    field :channel_id, :string
    field :category_id, :integer
    field :is_active, :boolean

    belongs_to :campaign, Repo.Campaign, type: :binary_id
    has_many :experiment_run, Repo.ExperimentRun, on_delete: :delete_all
    has_one :thumbnail, Repo.Thumbnail, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(experiment, attrs) do
    cols = [
      :category_id,
      :channel_id,
      :title,
      :video_id,
      :is_active
    ]

    # drops :is_active, not needed by default
    reqs = Enum.slice(cols, 0, length(cols) - 1)

    experiment
    |> cast(attrs, cols)
    |> validate_required(reqs)
  end
end
