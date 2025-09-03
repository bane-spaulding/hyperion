defmodule Hyperion.Repo do
  use Ecto.Repo,
    otp_app: :hyperion,
    adapter: Ecto.Adapters.Postgres
end
