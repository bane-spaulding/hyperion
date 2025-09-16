defmodule Hyperion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HyperionWeb.Telemetry,
      Hyperion.Repo,
      #      Hyperion.TokenRefresher,
      #{Hyperion.ViewTracker, "Xer-7tPXpUg,DCAyxxIaY04"},
      {DNSCluster, query: Application.get_env(:hyperion, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hyperion.PubSub},
      # Start a worker by calling: Hyperion.Worker.start_link(arg)
      # {Hyperion.Worker, arg},
      # Start to serve requests, typically the last entry
      HyperionWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hyperion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HyperionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
