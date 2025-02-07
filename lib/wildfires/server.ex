defmodule Wildfires.Server do
  @moduledoc """
  Websocket server for wildfires
  """

  require Logger

  @behaviour WebSock

  @impl WebSock
  def init(options) do
    {:ok, options}
  end

  @impl WebSock
  def handle_in({"ping", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  @impl WebSock
  def handle_info(input, state) do
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) when reason != :normal do
    Logger.error("Terminated", reason: reason)
    {:ok, state}
  end

  @impl WebSock
  def terminate(reason, state) do
    {:ok, state}
  end
end
