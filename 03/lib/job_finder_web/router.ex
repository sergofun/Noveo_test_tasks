defmodule JobFinderWeb.Router do
  use JobFinderWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", JobFinderWeb do
    pipe_through(:api)
    resources("/jobs", FinderController, only: [:index])
  end
end
