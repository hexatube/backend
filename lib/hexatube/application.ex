defmodule Hexatube.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HexatubeWeb.Telemetry,
      Hexatube.Repo,
      {DNSCluster, query: Application.get_env(:hexatube, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hexatube.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Hexatube.Finch},
      # Start a worker by calling: Hexatube.Worker.start_link(arg)
      # {Hexatube.Worker, arg},
      # Start to serve requests, typically the last entry
      HexatubeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hexatube.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HexatubeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
