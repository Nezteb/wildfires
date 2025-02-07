defmodule WildfiresTest do
  use Wildfires.RepoCase

  test "wildfires works" do
    Req.Test.stub(Wildfires.HTTPClient, fn conn ->
      Req.Test.json(conn, %{})
    end)

    :ok
  end
end
