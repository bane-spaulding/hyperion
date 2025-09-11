defmodule Hyperion.Repo.Migrations.CreateOauth2Token do
  use Ecto.Migration

  def change do
    create table(:oauth2_token) do
      add :refresh_token, :string
      add :access_token, :string

      timestamps(type: :utc_datetime)
    end
  end
end
