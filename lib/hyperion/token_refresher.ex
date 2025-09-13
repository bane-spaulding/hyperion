defmodule Hyperion.TokenRefresher do
  use GenServer

  require Logger

  import Ecto.Query, warn: false
  alias Hyperion.Repo

  alias Hyperion.Repo.Secret

  @token_endpoint "https://oauth2.googleapis.com/token"
  @refresh_interval :timer.minutes(55)
  @env_client_id "GOOGLE_CLIENT_ID"
  @env_client_secret "GOOGLE_CLIENT_SECRET"
  @env_token "REFRESH_TOKEN"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_token do
    GenServer.call(__MODULE__, :get_token)
  end

  @impl true
  def init(_) do
    # Load environment variables from .env file if present
    load_env_file()

    case getInitToken() do
      {:ok, token} ->
        Logger.debug("Obtained refresh_token: #{inspect(token)}")
        Kernel.send(self(), :refresh)
        Process.send_after(self(), :refresh, @refresh_interval)
        {:ok, token}

      {:stop, error} ->
        {:stop, error}
    end
  end

  @impl true
  def handle_call(:get_token, _from, current_token) do
    {:reply, current_token, current_token}
  end

  @impl true
  def handle_info(:refresh, current_token) do
    Logger.info("Refreshing OAuth2 Token...")

    case refresh_tokens(current_token) do
      {:ok, new_token} ->
        Logger.debug("Successfully refreshed token.")
        # Schedule the next refresh
        Process.send_after(self(), :refresh, @refresh_interval)
        {:noreply, new_token}

      {:error, reason} ->
        Logger.error("Failed to refresh token: #{reason}")
        # Stop the server on a fatal error
        {:stop, :refresh_failed, current_token}
    end
  end

  defp getInitToken() do
    # PK always 1 since that's the only secret we store
    case Repo.get(Secret, 1) do
      nil ->
        case System.get_env(@env_token) do
          nil ->
            {:stop, "Set REFRESH_TOKEN env var, no token provided."}

          token ->
            Logger.debug("Successfully retrieved token from env. #{inspect(token)}")

            %Secret{}
            |> Secret.changeset(%{refresh_token: token})
            |> Repo.insert()
        end

      token ->
        Logger.debug("Successfully retrieved token from db. #{inspect(token)}")
        {:ok, token}
    end
  end

  defp refresh_tokens(%Secret{refresh_token: refresh_token}=current_token) do
    with {:ok, config} <- get_oauth_config(),
         {:ok, access_token} <- refresh_token(refresh_token, config) do
      case persist_access_token(current_token, access_token) do
        {:ok, new_token} ->
          {:ok, new_token}

        {:stop, reason} ->
          {:error, reason}
      end
    else
      {:error, reason} ->
        {:error, reason}
      {:stop, reason} ->
        {:error, reason}
    end
  end

  # Load environment variables from .env file if present
  defp load_env_file do
    env_file = ".env"

    if File.exists?(env_file) do
      Logger.info("Loading environment variables from .env file")

      env_file
      |> File.read!()
      |> String.split("\n")
      |> Enum.each(fn line ->
        line = String.trim(line)

        # Skip empty lines and comments
        unless line == "" or String.starts_with?(line, "#") do
          case String.split(line, "=", parts: 2) do
            [key, value] ->
              # Remove quotes if present
              value = String.trim(value, "\"")
              System.put_env(key, value)

            _ ->
              :ignore
          end
        end
      end)
    end
  end

  defp get_oauth_config do
    client_id = System.get_env(@env_client_id)
    client_secret = System.get_env(@env_client_secret)

    if is_nil(client_secret) || is_nil(client_secret) do
      {:error, "Both #{@env_client_id}, #{@env_client_secret} env var are required"}
    else
      {:ok,
       %{
         client_id: client_id,
         client_secret: client_secret
       }}
    end
  end

  defp refresh_token(refresh_token, config) do
    Logger.info("Refreshing access token..")

    body = %{
      "refresh_token" => refresh_token,
      "client_id" => config.client_id,
      "client_secret" => config.client_secret,
      "grant_type" => "refresh_token"
    }

    case Req.post(@token_endpoint, form: body) do
      {:ok, %{status: 200, body: response}} ->
        {:ok,
         %{
           access_token: response["access_token"]
         }}

      {:ok, %{status: 400, body: %{"error" => "invalid_grant"}}} ->
        {:error,
         """
         Invalid refresh token. This can happen if:
         1. The refresh token has been revoked
         2. The OAuth2 app credentials have changed
         3. The token is corrupted
         """}

      {:ok, %{status: status, body: body}} ->
        {:error, "Token refresh failed (#{status}): #{inspect(body)}"}

      {:error, reason} ->
        {:error, "Network error: #{inspect(reason)}"}
    end
  end

  defp persist_access_token(secret, access_token) do
    secret
    |> Secret.changeset(access_token)
    |> Repo.update()
  end
end
