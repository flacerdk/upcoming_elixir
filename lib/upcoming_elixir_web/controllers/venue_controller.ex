defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller

  defp copenhagen_venues do
    [
      %Upcoming.Venue{id: "44268", name: "Loppen"},
      %Upcoming.Venue{id: "2740208", name: "Vega"},
      %Upcoming.Venue{id: "32939", name: "Pumpehuset"},
      %Upcoming.Venue{id: "34658", name: "Amager Bio"},
      %Upcoming.Venue{id: "66914", name: "Jazzhus Montmartre"},
      %Upcoming.Venue{id: "783451", name: "Bremen"},
      %Upcoming.Venue{id: "81192", name: "Ungdomshuset"},
      %Upcoming.Venue{id: "629926", name: "Forum"},
      %Upcoming.Venue{id: "3723574", name: "Hotel Cecil"},
      %Upcoming.Venue{id: "34460", name: "KB Hallen"},
      %Upcoming.Venue{id: "2543124", name: "Vega Musikkens Hus - Lille Vega (Small Hall)"},
      %Upcoming.Venue{id: "487526", name: "Huset-KBH"},
      %Upcoming.Venue{id: "32906", name: "Musikcaféen"},
      %Upcoming.Venue{id: "1287971", name: "Kb18"},
      %Upcoming.Venue{id: "54797", name: "Studenterhuset"},
      %Upcoming.Venue{id: "878476", name: "Kulturhuset Islands Brygge"},
      %Upcoming.Venue{id: "44329", name: "Valbyhallen"},
      %Upcoming.Venue{id: "1540388", name: "Stor Sal (Kransalen), Pumpehuset"},
      %Upcoming.Venue{id: "783411", name: "Den Sorte Diamant"},
      %Upcoming.Venue{id: "34270", name: "Telia Parken"},
      %Upcoming.Venue{id: "583056", name: "Koncerthuset, Koncertsalen"},
      %Upcoming.Venue{id: "69299", name: "Huset"},
      %Upcoming.Venue{id: "54162", name: "Den Grå Hal"},
      %Upcoming.Venue{id: "1500938", name: "Lille Sal (Sort Sal), Pumpehuset"},
      %Upcoming.Venue{id: "2564809", name: "Byhaven, Pumpehuset"},
      %Upcoming.Venue{id: "3756504", name: "Alice"},
      %Upcoming.Venue{id: "4179174", name: "Vega - Musikkens Hus, Store Vega"},
      %Upcoming.Venue{id: "4179234", name: "Ideal Bar, Vega - Musikkens Hus"}
    ]
  end

  def index(conn, _params) do
    render(conn, "index.html", venues: copenhagen_venues())
  end

  def show(conn, %{"venue_id" => venue_id} = params) do
    venue = Enum.find(copenhagen_venues(), fn %Upcoming.Venue{id: id} -> id == venue_id end)

    if venue == nil do
      conn |> put_status(:not_found) |> put_view(UpcomingWeb.ErrorView) |> render("404.html")
    else
      render(conn, "show.html", venue: venue)
    end
  end
end
