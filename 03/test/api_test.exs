defmodule ApiTest do
  @moduledoc false

  use JobFinderWeb.ConnCase

  import Mock

  setup_all do
    :ok
  end

  @json_response [
    %{"distance" => 100.0, "name" => "job1"},
    %{"distance" => 150.0, "name" => "job2"}
  ]

  @jobs_from_redis [["job2", "150"], ["job1", "100"]]

  @error_response_body "Wrong query string, supported format: ?latitude=[value]&longitude=[value]&radius=[value]"

  test "correct request", %{conn: conn} do
    with_mock(Redix, command: fn _, _ -> {:ok, @jobs_from_redis} end) do
      conn = get(conn, "/api/jobs?latitude=48.71&longitude=3.66&radius=50")
      assert %{"data" => @json_response} = json_response(conn, 200)
    end
  end

  test "wrong params", %{conn: conn} do
    conn = get(conn, "/api/jobs?latitude=48.71&longitude=3.66")
    assert 400 = conn.status
    assert @error_response_body = conn.resp_body
  end

end