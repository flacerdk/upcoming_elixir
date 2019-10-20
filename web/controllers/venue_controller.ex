defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller
  import Ecto.Query, only: [from: 2]

  def show(conn, %{"venue_id" => venue_id}) do
    venue =
      Upcoming.Repo.one(from v in Upcoming.Venue, where: ^venue_id == v.id, preload: [:events])

    if venue == nil do
      conn |> put_status(:not_found) |> put_view(UpcomingWeb.ErrorView) |> render("404.html")
    else
      render(conn, "show.html", venue: venue)
    end
  end
end
