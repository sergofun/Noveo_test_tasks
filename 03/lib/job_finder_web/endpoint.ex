defmodule JobFinderWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :job_finder

  plug(JobFinderWeb.Router)
end
