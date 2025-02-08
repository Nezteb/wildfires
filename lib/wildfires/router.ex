defmodule Wildfires.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  @second 1_000
  @minute 60 * @second
  @timeout 1 * @minute

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, "priv/static/index.html")
  end

  get "/ws" do
    conn
    |> WebSockAdapter.upgrade(Wildfires.Server, [], timeout: @timeout)
    |> halt()
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
