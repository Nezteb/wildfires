defmodule WildfiresTest do
  use Wildfires.RepoCase
  use Plug.Test

  test "wildfires works" do
    Req.Test.stub(Wildfires.HTTPClient, fn conn ->
      Req.Test.json(conn, %{})
    end)

    :ok
  end
end
