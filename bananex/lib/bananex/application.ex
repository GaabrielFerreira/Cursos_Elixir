defmodule Bananex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BananexWeb.Telemetry,
      Bananex.Repo,
      {DNSCluster, query: Application.get_env(:bananex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bananex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bananex.Finch},
      # Start a worker by calling: Bananex.Worker.start_link(arg)
      # {Bananex.Worker, arg},
      # Start to serve requests, typically the last entry
      BananexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bananex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BananexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
