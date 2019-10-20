defmodule UpcomingWeb.LocationController do
  use UpcomingWeb, :controller

  def index(conn, _params) do
    locations = Upcoming.Repo.all(Upcoming.Location)
    render(conn, "index.html", locations: locations)
  end

  def show(conn, %{"location_id" => location_id}) do
    import Ecto.Query, only: [from: 2]

    location = Upcoming.Repo.one(from l in Upcoming.Location, where: l.id == ^location_id)

    if location == nil do
      conn |> put_status(:not_found) |> put_view(UpcomingWeb.ErrorView) |> render("404.html")
    else
      render(conn, "show.html",
        location: location,
        venues: Upcoming.Location.venues_with_events(location)
      )
    end
  end
end
