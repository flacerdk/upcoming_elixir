defmodule UpcomingWeb.Router do
  use UpcomingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UpcomingWeb do
    pipe_through :browser

    get "/", LocationController, :index
    get "/:location_id", LocationController, :show
    get "/:location_id/venues/:venue_id", VenueController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", UpcomingWeb do
  #   pipe_through :api
  # end
end
