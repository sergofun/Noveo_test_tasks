defmodule JobFinderWeb.FinderController do
  @moduledoc false

  use JobFinderWeb, :controller

  alias JobFinder.RedisStorage

  def index(conn, _params) do
    conn
    |> Plug.Conn.fetch_query_params()
    |> Map.get(:query_params)
    |> case do
      %{"latitude" => latitude, "longitude" => longitude, "radius" => radius} ->
        json(conn, %{data: find_jobs(latitude, longitude, radius)})

      _ ->
        send_resp(
          conn,
          400,
          "Wrong query string, supported format: ?latitude=[value]&longitude=[value]&radius=[value]"
        )
    end
  end

  defp find_jobs(latitude, longitude, radius) do
    case RedisStorage.find_jobs(latitude, longitude, radius) do
      {:ok, jobs} ->
        jobs
        |> Enum.reduce([], fn [title, distance], acc ->
          {distance, _} = Float.parse(distance)
          [%{name: title, distance: distance} | acc]
        end)
        |> Enum.sort(&(&1.distance < &2.distance))

      _ ->
        []
    end
  end
end
