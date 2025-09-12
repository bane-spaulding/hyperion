defmodule Hyperion.Oauth2TokenTest do
  use Hyperion.DataCase

  alias Hyperion.Oauth2Token

  describe "oauth2_token" do
    alias Hyperion.Oauth2Token.Secrets

    import Hyperion.Oauth2TokenFixtures

    @invalid_attrs %{scope: nil, access_token: nil, expires_in: nil, token_type: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secrets = secrets_fixture()
      assert Oauth2Token.list_oauth2_token() == [secrets]
    end

    test "get_secrets!/1 returns the secrets with given id" do
      secrets = secrets_fixture()
      assert Oauth2Token.get_secrets!(secrets.id) == secrets
    end

    test "create_secrets/1 with valid data creates a secrets" do
      valid_attrs = %{
        scope: "some scope",
        access_token: "some access_token",
        expires_in: 42,
        token_type: "some token_type"
      }

      assert {:ok, %Secrets{} = secrets} = Oauth2Token.create_secrets(valid_attrs)
      assert secrets.scope == "some scope"
      assert secrets.access_token == "some access_token"
      assert secrets.expires_in == 42
      assert secrets.token_type == "some token_type"
    end

    test "create_secrets/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Oauth2Token.create_secrets(@invalid_attrs)
    end

    test "update_secrets/2 with valid data updates the secrets" do
      secrets = secrets_fixture()

      update_attrs = %{
        scope: "some updated scope",
        access_token: "some updated access_token",
        expires_in: 43,
        token_type: "some updated token_type"
      }

      assert {:ok, %Secrets{} = secrets} = Oauth2Token.update_secrets(secrets, update_attrs)
      assert secrets.scope == "some updated scope"
      assert secrets.access_token == "some updated access_token"
      assert secrets.expires_in == 43
      assert secrets.token_type == "some updated token_type"
    end

    test "update_secrets/2 with invalid data returns error changeset" do
      secrets = secrets_fixture()
      assert {:error, %Ecto.Changeset{}} = Oauth2Token.update_secrets(secrets, @invalid_attrs)
      assert secrets == Oauth2Token.get_secrets!(secrets.id)
    end

    test "delete_secrets/1 deletes the secrets" do
      secrets = secrets_fixture()
      assert {:ok, %Secrets{}} = Oauth2Token.delete_secrets(secrets)
      assert_raise Ecto.NoResultsError, fn -> Oauth2Token.get_secrets!(secrets.id) end
    end

    test "change_secrets/1 returns a secrets changeset" do
      secrets = secrets_fixture()
      assert %Ecto.Changeset{} = Oauth2Token.change_secrets(secrets)
    end
  end

  describe "oauth2_token" do
    alias Hyperion.Oauth2Token.Repo.Secret

    import Hyperion.Oauth2TokenFixtures

    @invalid_attrs %{refresh_token: nil, access_token: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secret = secret_fixture()
      assert Oauth2Token.list_oauth2_token() == [secret]
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Oauth2Token.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      valid_attrs = %{refresh_token: "some refresh_token", access_token: "some access_token"}

      assert {:ok, %Secret{} = secret} = Oauth2Token.create_secret(valid_attrs)
      assert secret.refresh_token == "some refresh_token"
      assert secret.access_token == "some access_token"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Oauth2Token.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()

      update_attrs = %{
        refresh_token: "some updated refresh_token",
        access_token: "some updated access_token"
      }

      assert {:ok, %Secret{} = secret} = Oauth2Token.update_secret(secret, update_attrs)
      assert secret.refresh_token == "some updated refresh_token"
      assert secret.access_token == "some updated access_token"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Oauth2Token.update_secret(secret, @invalid_attrs)
      assert secret == Oauth2Token.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Oauth2Token.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Oauth2Token.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Oauth2Token.change_secret(secret)
    end
  end
end
