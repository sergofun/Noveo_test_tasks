defmodule JobFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias JobFinder.RedisStorage

  use Application

  @impl true
  def start(_type, _args) do
    children =
      :job_finder
      |> Application.get_env(:storage_child)
      |> case do
        nil -> [JobFinderWeb.Endpoint]
        storage_child -> [JobFinderWeb.Endpoint, storage_child]
      end

    children
    |> Supervisor.start_link(strategy: :one_for_one, name: JobFinder.Supervisor)
    |> tap(&fill_in_db(&1, Application.get_env(:job_finder, :storage_child)))
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JobFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp fill_in_db(_, nil),
    do: :do_nothing

  defp fill_in_db(_, _) do
    "#{:code.priv_dir(:job_finder)}/#{Application.fetch_env!(:job_finder, :jobs_file)}"
    |> File.stream!()
    |> CSV.decode!()
    |> Enum.each(&RedisStorage.add(&1))
  end
end
