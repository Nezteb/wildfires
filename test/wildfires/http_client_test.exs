defmodule Wildfires.HTTPClientTest do
  use Wildfires.RepoCase
  use Plug.Test

  describe "HTTP Client" do
    setup :setup_api

    test "happy path works" do
      assert {:ok, response} = Wildfires.HTTPClient.get_wildfires()
      assert Enum.count(response["features"]) == 7
    end
  end

  defp setup_api(_context) do
    wildfires = load_fixture("feature_server.1.query.json")

    Req.Test.stub(Wildfires.HTTPClient, fn conn ->
      Req.Test.json(conn, wildfires)
    end)

    %{wildfires: wildfires}
  end

  defp load_fixture(filename) do
    [File.cwd!(), "test", "fixtures", filename]
    |> Path.join()
    |> File.read!()
    |> Jason.decode!()
  end
end
