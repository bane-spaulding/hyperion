defmodule Hyperion.Oauth2TokenFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hyperion.Oauth2Token` context.
  """

  @doc """
  Generate a secrets.
  """
  def secrets_fixture(attrs \\ %{}) do
    {:ok, secrets} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        expires_in: 42,
        scope: "some scope",
        token_type: "some token_type"
      })
      |> Hyperion.Oauth2Token.create_secrets()

    secrets
  end

  @doc """
  Generate a secret.
  """
  def secret_fixture(attrs \\ %{}) do
    {:ok, secret} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        refresh_token: "some refresh_token"
      })
      |> Hyperion.Oauth2Token.create_secret()

    secret
  end
end
