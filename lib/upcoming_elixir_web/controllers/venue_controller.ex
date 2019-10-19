defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller
  import Ecto.Query, only: [from: 2]

  def index(conn, %{"location_id" => location_id}) do
    venues =
      Upcoming.Repo.all(
        from v in Upcoming.Venue, where: ^location_id == v.location_id, preload: [:events]
      )
      |> Enum.filter(fn v -> length(v.events) > 0 end)

    render(conn, "index.html", venues: venues)
  end

  def show(conn, %{"venue_id" => venue_id}) do
    venue = Upcoming.Repo.one(from v in Upcoming.Venue, where: ^venue_id == v.id)

    if venue == nil do
      conn |> put_status(:not_found) |> put_view(UpcomingWeb.ErrorView) |> render("404.html")
    else
      events = Upcoming.Venue.get_calendar(venue)
      render(conn, "show.html", events: events)
    end
  end
end
