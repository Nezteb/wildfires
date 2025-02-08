defmodule Wildfires.Server do
  @moduledoc """
  Websocket server for wildfires.

  TODO: Fetch from DB instead of querying each time.
  """

  require Logger

  @behaviour WebSock

  @impl WebSock
  def init(options) do
    {:ok, options}
  end

  @impl WebSock
  def handle_in({"ping", [opcode: :text]}, state) do
    Logger.info("pong")
    {:reply, :ok, {:text, "pong"}, state}
  end

  @impl WebSock
  def handle_in({"get", [opcode: :text]}, state) do
    {:reply, :ok, {:text, Jason.encode!(state)}, state}
  end

  @impl WebSock
  def handle_in({"refresh", [opcode: :text]}, state) do
    {:ok, wildfires} = do_fetch(state)
    {:reply, :ok, {:text, Jason.encode!(wildfires)}, wildfires}
  end

  @impl WebSock
  def handle_in({message, _opcode}, state) do
    Logger.info("#{__MODULE__} unhandled message", message: message)
    {:ok, state}
  end

  @impl WebSock
  def handle_info(input, state) do
    Logger.info("#{__MODULE__} received message", input: inspect(input))
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) when reason != :normal do
    Logger.error("#{__MODULE__} terminated", reason: reason)
    {:ok, state}
  end

  @impl WebSock
  def terminate(_reason, state) do
    {:ok, state}
  end

  defp do_fetch(state) do
    case Wildfires.HTTPClient.get_wildfires() do
      {:ok, wildfires} ->
        {:ok, wildfires}

      {:error, error} ->
        Logger.error("API fetch error", error: inspect(error))
        {:ok, state}
        # TODO: We could also stop on errors (in the case upstream API is down)
        # {:stop, :api_fetch_error, error}
    end
  end
end
