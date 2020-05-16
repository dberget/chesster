defmodule ChessterWeb.Router do
  use ChessterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChessterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChessterWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/matches", MatchLive.Index, :index
    live "/matches/new", MatchLive.Index, :new
    live "/matches/:id/edit", MatchLive.Index, :edit

    live "/matches/:id", MatchLive.Show, :show
    live "/matches/:id/show/edit", MatchLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChessterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ChessterWeb.Telemetry
    end
  end
end
