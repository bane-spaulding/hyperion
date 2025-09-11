defmodule Hyperion.Repo.Secret do
  use Ecto.Schema
  import Ecto.Changeset

  schema "oauth2_token" do
    field :refresh_token, :string
    field :access_token, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(secret, attrs) do
    secret
    |> cast(attrs, [:refresh_token, :access_token])
    |> validate_required([:refresh_token])
  end
end
