defmodule Mix.Tasks.Aggregate do
  @moduledoc """
    usage:
      $ mix aggregate professions_file job_offers_file
    professions_file - path to the professions cvs file in the following format:
      id,name,category_name
    job_offers_file - path to the job offers cvs file in the following format:
      profession_id,contract_type,name,office_latitude,office_longitude

    Without any parameters script uses prepared samples from priv directory
  """

  @columns_names_str ~w[profession_id contract_type name office_latitude office_longitude]

  @continents_polygons [
    %{
      continent: "NorthAmerica",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {90, -168.75},
            {90, -10},
            {78.13, -10},
            {57.5, -37.5},
            {15, -30},
            {15, -75},
            {1.25, -82.5},
            {1.25, -105},
            {51, -180},
            {60, -180},
            {60, -168.75}
          ]
        ]
      }
    },
    %{
      continent: "NorthAmerica",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {51, 166.6},
            {51, 180},
            {60, 180}
          ]
        ]
      }
    },
    %{
      continent: "SouthAmerica",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {51, -180},
            {1.25, -105},
            {1.25, -82.5},
            {15, -75},
            {15, -30},
            {-60, -30},
            {-60, -180}
          ]
        ]
      }
    },
    %{
      continent: "Australia",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {-11.88, 110},
            {-11.88, 180},
            {-60, 180},
            {-60, 110}
          ]
        ]
      }
    },
    %{
      continent: "Europe",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {90, -10},
            {90, 77.5},
            {42.5, 48.8},
            {42.5, 30},
            {40.79, 28.81},
            {41, 29},
            {40.55, 27.31},
            {40.40, 26.75},
            {40.05, 26.36},
            {39.17, 25.19},
            {35.46, 27.91},
            {33, 27.5},
            {38, 10},
            {35.42, -10},
            {28.25, -13},
            {15, -30},
            {57.5, -37.5},
            {78.13, -10}
          ]
        ]
      }
    },
    %{
      continent: "Africa",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {15, -30},
            {28.25, -13},
            {35.42, -10},
            {38, 10},
            {33, 27.5},
            {31.74, 34.58},
            {29.54, 34.92},
            {27.78, 34.46},
            {11.3, 44.3},
            {12.5, 52},
            {-60, 75},
            {-60, -30}
          ]
        ]
      }
    },
    %{
      continent: "Asia",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {90, 77.5},
            {42.5, 48.8},
            {42.5, 30},
            {40.79, 28.81},
            {41, 29},
            {40.55, 27.31},
            {40.4, 26.75},
            {40.05, 26.36},
            {39.17, 25.19},
            {35.46, 27.91},
            {33, 27.5},
            {31.74, 34.58},
            {29.54, 34.92},
            {27.78, 34.46},
            {11.3, 44.3},
            {12.5, 52},
            {-60, 75},
            {-60, 110},
            {-31.88, 110},
            {-11.88, 110},
            {-11.88, 180},
            {51, 180},
            {51, 166.6},
            {60, 180},
            {90, 180}
          ]
        ]
      }
    },
    %{
      continent: "Asia",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {90, -180},
            {90, -168.75},
            {60, -168.75},
            {60, -180}
          ]
        ]
      }
    },
    %{
      continent: "Antarctica",
      polygon: %Geo.Polygon{
        coordinates: [
          [
            {-60, -180},
            {-60, 180},
            {-90, 180},
            {-90, -180}
          ]
        ]
      }
    }
  ]

  require Logger

  use Mix.Task

  def run([]) do
    professions_file = "#{:code.priv_dir(:continets_grouping)}/technical-test-professions.csv"
    job_offers_file = "#{:code.priv_dir(:continets_grouping)}/technical-test-jobs.csv"
    run([professions_file, job_offers_file])
  end

  def run([professions_file, job_offers_file]) do
    # get professions
    professions = prepare_professions(professions_file)

    job_offers_file
    |> File.stream!()
    |> CSV.decode!()
    |> Enum.reduce(
      %{
        "Total" => %{},
        "NorthAmerica" => %{},
        "SouthAmerica" => %{},
        "Australia" => %{},
        "Europe" => %{},
        "Africa" => %{},
        "Asia" => %{},
        "Antarctica" => %{}
      },
      &update_statistics(&1, &2, professions)
    )
    |> Enum.each(fn {continent, statistic} ->
      Logger.info("#{continent}:")
      Enum.each(statistic, fn {category, value} -> Logger.info("\t#{category} - #{value}") end)
    end)

    # rescue
  end

  def run(_), do: IO.puts(@moduledoc)

  defp update_statistics(@columns_names_str, statistics, _professions),
    do: statistics

  defp update_statistics(
         [profession_id, _, _, latitude, longitude] = record,
         statistics,
         _professions
       )
       when profession_id == ""
       when latitude == ""
       when longitude == "" do
    Logger.warn("Malformed job record: #{inspect(record)}, skip it")
    statistics
  end

  defp update_statistics([profession_id, _, _, latitude, longitude], statistics, professions) do
    continent = get_continent(String.to_float(latitude), String.to_float(longitude))
    category = professions[profession_id]

    statistics
    |> update_in(["Total", category], fn
      nil -> 1
      old_value -> old_value + 1
    end)
    |> update_in([continent, category], fn
      nil -> 1
      old_value -> old_value + 1
    end)
  end

  defp get_continent(latitude, longitude) do
    %{continent: continent} =
      Enum.find(@continents_polygons, fn %{polygon: polygon} ->
          Topo.contains?(polygon, %Geo.Point{coordinates: {latitude, longitude}})
      end)

    continent
  end

  def prepare_professions(professions_file) do
    professions_file
    |> File.stream!()
    |> CSV.decode!()
    |> Enum.into(%{}, fn [id, _name, category] -> {id, category} end)
  end
end
