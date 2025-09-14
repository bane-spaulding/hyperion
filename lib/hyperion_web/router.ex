defmodule HyperionWeb.Router do
  use HyperionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HyperionWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HyperionWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/ping", PingController, :ping
    #resources "/experiments", ExperimentController
    live "/experiments", ExperimentLive.Index, :index
    live "/experiments/new", ExperimentLive.Form, :new
    live "/experiments/:id", ExperimentLive.Show, :show
    live "/experiments/:id/edit", ExperimentLive.Form, :edit

    live "/thermostat", ThermostatLive
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:hyperion, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HyperionWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
