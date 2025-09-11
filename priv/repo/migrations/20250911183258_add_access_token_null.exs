defmodule Hyperion.Repo.Migrations.AddAccessTokenNull do
  use Ecto.Migration

  def change do
    alter table(:oauth2_token) do
      modify(:access_token, :string, null: true)
    end
  end
end
