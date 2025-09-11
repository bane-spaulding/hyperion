defmodule HyperionWeb.SecretsControllerTest do
  use HyperionWeb.ConnCase

  import Hyperion.Oauth2TokenFixtures
  alias Hyperion.Oauth2Token.Secrets

  @create_attrs %{
    scope: "some scope",
    access_token: "some access_token",
    expires_in: 42,
    token_type: "some token_type"
  }
  @update_attrs %{
    scope: "some updated scope",
    access_token: "some updated access_token",
    expires_in: 43,
    token_type: "some updated token_type"
  }
  @invalid_attrs %{scope: nil, access_token: nil, expires_in: nil, token_type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all oauth2_token", %{conn: conn} do
      conn = get(conn, ~p"/api/oauth2_token")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create secrets" do
    test "renders secrets when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/oauth2_token", secrets: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/oauth2_token/#{id}")

      assert %{
               "id" => ^id,
               "access_token" => "some access_token",
               "expires_in" => 42,
               "scope" => "some scope",
               "token_type" => "some token_type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/oauth2_token", secrets: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update secrets" do
    setup [:create_secrets]

    test "renders secrets when data is valid", %{conn: conn, secrets: %Secrets{id: id} = secrets} do
      conn = put(conn, ~p"/api/oauth2_token/#{secrets}", secrets: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/oauth2_token/#{id}")

      assert %{
               "id" => ^id,
               "access_token" => "some updated access_token",
               "expires_in" => 43,
               "scope" => "some updated scope",
               "token_type" => "some updated token_type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, secrets: secrets} do
      conn = put(conn, ~p"/api/oauth2_token/#{secrets}", secrets: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete secrets" do
    setup [:create_secrets]

    test "deletes chosen secrets", %{conn: conn, secrets: secrets} do
      conn = delete(conn, ~p"/api/oauth2_token/#{secrets}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/oauth2_token/#{secrets}")
      end
    end
  end

  defp create_secrets(_) do
    secrets = secrets_fixture()

    %{secrets: secrets}
  end
end
