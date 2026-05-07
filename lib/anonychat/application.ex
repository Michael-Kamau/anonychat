defmodule Anonychat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AnonychatWeb.Telemetry,
      Anonychat.Repo,
      {DNSCluster, query: Application.get_env(:anonychat, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Anonychat.PubSub},
      # Start a worker by calling: Anonychat.Worker.start_link(arg)
      # {Anonychat.Worker, arg},
      # Start to serve requests, typically the last entry
      AnonychatWeb.Endpoint,

      # AMQP consumer worker
      Anonychat.Amqp.AmqpConsumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Anonychat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnonychatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
