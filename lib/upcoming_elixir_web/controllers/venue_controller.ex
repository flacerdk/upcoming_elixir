defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller

  def copenhagen_venues do
    import Ecto.Query, only: [from: 2]

    Upcoming.Repo.all(from v in Upcoming.Venue, preload: [:events])
    |> Enum.filter(fn v -> length(v.events) > 0 end)
  end

  def index(conn, _params) do
    render(conn, "index.html", venues: copenhagen_venues())
  end

  def show(conn, %{"venue_id" => venue_id}) do
    venue =
      Enum.find(copenhagen_venues(), fn %Upcoming.Venue{songkick_id: id} -> id == venue_id end)

    if venue == nil do
      conn |> put_status(:not_found) |> put_view(UpcomingWeb.ErrorView) |> render("404.html")
    else
      events = Upcoming.Venue.get_calendar(venue)
      render(conn, "show.html", events: events)
    end
  end
end
