defmodule Wildfires.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    config =
      :wildfires
      |> Application.get_all_env()
      |> Map.new()
      |> inspect()

    Logger.info("Starting #{__MODULE__}", config: config)

    opt_ins = []
    OpentelemetryBandit.setup(opt_in_attrs: opt_ins)

    :ok = OpentelemetryEcto.setup([:wildfires, :repo])

    children = [
      # Starts a worker by calling: Wildfires.Worker.start_link(arg)
      # {Wildfires.Worker, arg}
      Wildfires.Repo,
      {Bandit, plug: Wildfires.Router, scheme: :http, port: 4000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wildfires.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
