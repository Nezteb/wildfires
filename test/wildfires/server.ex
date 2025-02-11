defmodule Wildfires.ServerTest do
  use ExUnit.Case

  describe "Websocket server" do
    setup [:setup_server, :load_fixtures]

    test "ping works and state is unchanged" do
      Req.Test.stub(Wildfires.HTTPClient, fn conn ->
        Req.Test.json(conn, [])
      end)

      response = Wildfires.Server.handle_in({"ping", [opcode: :text]}, [])
      assert {:reply, "pong", []} = response
    end

    test "get works and returns state", %{wildfires: wildfires} do
      Req.Test.stub(Wildfires.HTTPClient, fn conn ->
        Req.Test.json(conn, wildfires)
      end)

      response = Wildfires.Server.handle_in({"get", [opcode: :text]}, wildfires)
      assert {:reply, json_state, _state} = response
      assert ^wildfires = Jason.decode!(json_state)
    end

    test "refresh works and refreshes state", %{wildfires: wildfires} do
      Req.Test.stub(Wildfires.HTTPClient, fn conn ->
        Req.Test.json(conn, wildfires)
      end)

      response = Wildfires.Server.handle_in({"refresh", [opcode: :text]}, [])
      assert {:reply, json_state, _state} = response
      assert ^wildfires = Jason.decode!(json_state)
    end

    test "upstream api error results in same state" do
      Req.Test.expect(Wildfires.HTTPClient, fn conn ->
        Plug.Conn.send_resp(conn, 500, "internal server error")
      end)

      wildfires = [
        %{
          "type" => "Feature",
          "geometry" => %{
            "type" => "MultiPolygon",
            "coordinates" => []
          },
          "properties" => %{
            "IncidentName" => "Horton"
          }
        }
      ]

      response = Wildfires.Server.handle_in({"refresh", [opcode: :text]}, wildfires)
      assert {:reply, json_state, _state} = response
      assert ^wildfires = Jason.decode!(json_state)
    end
  end

  defp setup_server(_context) do
    {:ok, []} = Wildfires.Server.init(skip_fetch: true)
    :ok
  end

  defp load_fixtures(_context) do
    wildfires = load_fixture("feature_server.1.query.json")

    %{wildfires: wildfires}
  end

  defp load_fixture(filename) do
    [File.cwd!(), "test", "fixtures", filename]
    |> Path.join()
    |> File.read!()
    |> Jason.decode!()
  end
end
