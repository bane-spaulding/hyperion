defmodule Hyperion.SecretsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hyperion.Secrets` context.
  """

  @doc """
  Generate a secret.
  """
  def secret_fixture(attrs \\ %{}) do
    {:ok, secret} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token",
        expires_in: 42,
        scope: "some scope",
        token_type: "some token_type"
      })
      |> Hyperion.Secrets.create_secret()

    secret
  end

  @doc """
  Generate a secret.
  """
  def secret_fixture(attrs \\ %{}) do
    {:ok, secret} =
      attrs
      |> Enum.into(%{
        access_token: "some access_token"
      })
      |> Hyperion.Secrets.create_secret()

    secret
  end

  @doc """
  Generate a secret.
  """
  def secret_fixture(attrs \\ %{}) do
    {:ok, secret} =
      attrs
      |> Enum.into(%{
        refresh_token: "some refresh_token"
      })
      |> Hyperion.Secrets.create_secret()

    secret
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
      |> Hyperion.Secrets.create_secret()

    secret
  end
end
