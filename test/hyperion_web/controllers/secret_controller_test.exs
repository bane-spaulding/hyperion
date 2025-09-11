defmodule HyperionWeb.SecretControllerTest do
  use HyperionWeb.ConnCase

  import Hyperion.Oauth2TokenFixtures
  alias Hyperion.Oauth2Token.Repo.Secret

  @create_attrs %{
    refresh_token: "some refresh_token",
    access_token: "some access_token"
  }
  @update_attrs %{
    refresh_token: "some updated refresh_token",
    access_token: "some updated access_token"
  }
  @invalid_attrs %{refresh_token: nil, access_token: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all oauth2_token", %{conn: conn} do
      conn = get(conn, ~p"/api/oauth2_token")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create secret" do
    test "renders secret when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/oauth2_token", secret: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/oauth2_token/#{id}")

      assert %{
               "id" => ^id,
               "access_token" => "some access_token",
               "refresh_token" => "some refresh_token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/oauth2_token", secret: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update secret" do
    setup [:create_secret]

    test "renders secret when data is valid", %{conn: conn, secret: %Secret{id: id} = secret} do
      conn = put(conn, ~p"/api/oauth2_token/#{secret}", secret: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/oauth2_token/#{id}")

      assert %{
               "id" => ^id,
               "access_token" => "some updated access_token",
               "refresh_token" => "some updated refresh_token"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, secret: secret} do
      conn = put(conn, ~p"/api/oauth2_token/#{secret}", secret: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete secret" do
    setup [:create_secret]

    test "deletes chosen secret", %{conn: conn, secret: secret} do
      conn = delete(conn, ~p"/api/oauth2_token/#{secret}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/oauth2_token/#{secret}")
      end
    end
  end

  defp create_secret(_) do
    secret = secret_fixture()

    %{secret: secret}
  end
end
