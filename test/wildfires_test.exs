defmodule WildfiresTest do
  use Wildfires.RepoCase
  use Plug.Test

  test "wildfires works" do
    Req.Test.stub(Wildfires.HTTPClient, fn conn ->
      Req.Test.json(conn, %{})
    end)

    Req.Test.expect(MyStub, &Plug.Conn.send_resp(&1, 200, "ok"))

    :ok
  end
end
