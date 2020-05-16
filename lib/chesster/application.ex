defmodule Chesster.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Chesster.Repo,
      ChessterWeb.Telemetry,
      {Phoenix.PubSub, name: Chesster.PubSub},
      ChessterWeb.Endpoint,
      {Registry, keys: :unique, name: :chesster}
    ]

    opts = [strategy: :one_for_one, name: Chesster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ChessterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
