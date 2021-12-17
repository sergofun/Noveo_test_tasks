defmodule JobFinder.RedisStorage do
  @moduledoc false

  @type latitude :: String.t()
  @type longitude :: String.t()
  @type radius :: String.t()
  @type job_name :: String.t()
  @type distance :: String.t()

  @columns_names_str ~w[profession_id contract_type name office_latitude office_longitude]
  @conn_name :redix
  @key "jobs"

  @spec add([String.t()]) :: {:ok, term()} | {:error, term()}
  def add(@columns_names_str),
    do: {:ok, :do_nothing}

  def add([_profession_id, _contract_type, name, latitude, longitude])
      when name == ""
      when latitude == ""
      when longitude == "" do
    {:ok, :do_nothing}
  end

  def add([_profession_id, _contract_type, name, latitude, longitude]),
    do:
      Redix.command(@conn_name, [
        "GEOADD",
        @key,
        String.to_float(latitude),
        String.to_float(longitude),
        name
      ])

  @spec find_jobs(latitude(), longitude(), radius()) :: {:ok, [String.t()]} | {:error, term()}
  def find_jobs(latitude, longitude, radius) do
    {latitude, _} = Float.parse(latitude)
    {longitude, _} = Float.parse(longitude)
    {radius, _} = Float.parse(radius)

    Redix.command(@conn_name, [
      "GEOSEARCH",
      @key,
      "FROMLONLAT",
      latitude,
      longitude,
      "BYRADIUS",
      radius,
      "km",
      "WITHDIST"
    ])
  end
end
