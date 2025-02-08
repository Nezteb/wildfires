defmodule Wildfires.Cron do
  @moduledoc """
  A simple cron worker meant to fetch wildfire data
  at a regular interval.

  TODO: Store incidents in DB.
  """

  use GenServer

  require Logger

  @cron_interval 1
  @cron_unit :hour

  # Client API

  def start_link(opts \\ []) do
    Logger.info("#{__MODULE__} start_link", opts: inspect(opts))

    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  # Server callbacks

  @impl GenServer
  def init(opts) do
    Logger.info("#{__MODULE__} init", opts: inspect(opts))
    {:ok, opts, {:continue, :work}}
  end

  @impl GenServer
  def handle_continue(:work, state) do
    do_work(state)
  end

  @impl GenServer
  def handle_info(:work, state) do
    do_work(state)
  end

  @impl GenServer
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  # Private functions

  defp do_work(state) do
    case Wildfires.HTTPClient.get_wildfires() do
      {:ok, work} ->
        Logger.info("#{__MODULE__} work success", bytes: :erts_debug.size(work))
        schedule_work()
        {:noreply, work}

      {:error, error} ->
        Logger.error("#{__MODULE__} work error", error: inspect(error))
        {:noreply, state}
        # TODO: We could also stop on errors (in the case upstream API is down)
        # {:stop, :cron_error, error}
    end
  end

  defp schedule_work() do
    now = DateTime.utc_now()
    next_run_time = DateTime.add(now, @cron_interval, @cron_unit)

    Logger.info("#{__MODULE__} scheduling work",
      next_run_time: DateTime.to_iso8601(next_run_time)
    )

    diff_ms = DateTime.diff(next_run_time, now, :millisecond)
    Process.send_after(self(), :work, diff_ms)
  end
end
