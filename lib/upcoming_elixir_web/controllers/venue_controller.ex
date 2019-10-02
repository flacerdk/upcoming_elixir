defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller

  def copenhagen_venues do
    Upcoming.Venue |> Upcoming.Repo.all()
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
      render(conn, "show.html", venue: venue)
    end
  end
end
