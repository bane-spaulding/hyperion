defmodule Hyperion.SecretsTest do
  use Hyperion.DataCase

  alias Hyperion.Secrets

  describe "oauth2_token" do
    alias Hyperion.Secrets.Secret

    import Hyperion.SecretsFixtures

    @invalid_attrs %{scope: nil, access_token: nil, expires_in: nil, token_type: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secret = secret_fixture()
      assert Secrets.list_oauth2_token() == [secret]
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Secrets.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      valid_attrs = %{scope: "some scope", access_token: "some access_token", expires_in: 42, token_type: "some token_type"}

      assert {:ok, %Secret{} = secret} = Secrets.create_secret(valid_attrs)
      assert secret.scope == "some scope"
      assert secret.access_token == "some access_token"
      assert secret.expires_in == 42
      assert secret.token_type == "some token_type"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Secrets.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()
      update_attrs = %{scope: "some updated scope", access_token: "some updated access_token", expires_in: 43, token_type: "some updated token_type"}

      assert {:ok, %Secret{} = secret} = Secrets.update_secret(secret, update_attrs)
      assert secret.scope == "some updated scope"
      assert secret.access_token == "some updated access_token"
      assert secret.expires_in == 43
      assert secret.token_type == "some updated token_type"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Secrets.update_secret(secret, @invalid_attrs)
      assert secret == Secrets.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Secrets.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Secrets.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Secrets.change_secret(secret)
    end
  end

  describe "oauth2_token" do
    alias Hyperion.Secrets.Secret

    import Hyperion.SecretsFixtures

    @invalid_attrs %{access_token: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secret = secret_fixture()
      assert Secrets.list_oauth2_token() == [secret]
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Secrets.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      valid_attrs = %{access_token: "some access_token"}

      assert {:ok, %Secret{} = secret} = Secrets.create_secret(valid_attrs)
      assert secret.access_token == "some access_token"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Secrets.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()
      update_attrs = %{access_token: "some updated access_token"}

      assert {:ok, %Secret{} = secret} = Secrets.update_secret(secret, update_attrs)
      assert secret.access_token == "some updated access_token"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Secrets.update_secret(secret, @invalid_attrs)
      assert secret == Secrets.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Secrets.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Secrets.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Secrets.change_secret(secret)
    end
  end

  describe "oauth2_token" do
    alias Hyperion.Secrets.Secret

    import Hyperion.SecretsFixtures

    @invalid_attrs %{refresh_token: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secret = secret_fixture()
      assert Secrets.list_oauth2_token() == [secret]
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Secrets.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      valid_attrs = %{refresh_token: "some refresh_token"}

      assert {:ok, %Secret{} = secret} = Secrets.create_secret(valid_attrs)
      assert secret.refresh_token == "some refresh_token"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Secrets.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()
      update_attrs = %{refresh_token: "some updated refresh_token"}

      assert {:ok, %Secret{} = secret} = Secrets.update_secret(secret, update_attrs)
      assert secret.refresh_token == "some updated refresh_token"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Secrets.update_secret(secret, @invalid_attrs)
      assert secret == Secrets.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Secrets.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Secrets.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Secrets.change_secret(secret)
    end
  end

  describe "oauth2_token" do
    alias Hyperion.Secrets.Secret

    import Hyperion.SecretsFixtures

    @invalid_attrs %{refresh_token: nil, access_token: nil}

    test "list_oauth2_token/0 returns all oauth2_token" do
      secret = secret_fixture()
      assert Secrets.list_oauth2_token() == [secret]
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Secrets.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      valid_attrs = %{refresh_token: "some refresh_token", access_token: "some access_token"}

      assert {:ok, %Secret{} = secret} = Secrets.create_secret(valid_attrs)
      assert secret.refresh_token == "some refresh_token"
      assert secret.access_token == "some access_token"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Secrets.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()
      update_attrs = %{refresh_token: "some updated refresh_token", access_token: "some updated access_token"}

      assert {:ok, %Secret{} = secret} = Secrets.update_secret(secret, update_attrs)
      assert secret.refresh_token == "some updated refresh_token"
      assert secret.access_token == "some updated access_token"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Secrets.update_secret(secret, @invalid_attrs)
      assert secret == Secrets.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Secrets.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Secrets.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Secrets.change_secret(secret)
    end
  end
end
