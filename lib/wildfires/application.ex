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

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wildfires.Supervisor]

    Application.get_env(:wildfires, :env, :dev)
    |> maybe_start_telemetry()
    |> get_children_for_env()
    |> merge_common_children()
    |> Supervisor.start_link(opts)
  after
    Logger.critical("Open http://localhost:4000")
  end

  defp maybe_start_telemetry(env) when env in [:prod] do
    :ok = OpentelemetryBandit.setup(opt_in_attrs: [])
    :ok = OpentelemetryEcto.setup([:wildfires, :repo])
    env
  end

  defp maybe_start_telemetry(env), do: env

  defp get_children_for_env(:test), do: []
  defp get_children_for_env(_), do: [Wildfires.Cron]

  defp merge_common_children(children),
    do: [Wildfires.Repo, {Bandit, plug: Wildfires.Router, scheme: :http, port: 4000}] ++ children
end
