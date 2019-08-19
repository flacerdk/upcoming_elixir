defmodule UpcomingWeb.VenueController do
  use UpcomingWeb, :controller

  defp copenhagen_venues do
    [
      %Upcoming.Venue{id: 44268, name: "Loppen"},
      %Upcoming.Venue{id: 2_740_208, name: "Vega"},
      %Upcoming.Venue{id: 32939, name: "Pumpehuset"},
      %Upcoming.Venue{id: 34658, name: "Amager Bio"},
      %Upcoming.Venue{id: 66914, name: "Jazzhus Montmartre"},
      %Upcoming.Venue{id: 783_451, name: "Bremen"},
      %Upcoming.Venue{id: 81192, name: "Ungdomshuset"},
      %Upcoming.Venue{id: 629_926, name: "Forum"},
      %Upcoming.Venue{id: 3_723_574, name: "Hotel Cecil"},
      %Upcoming.Venue{id: 34460, name: "KB Hallen"},
      %Upcoming.Venue{id: 2_543_124, name: "Vega Musikkens Hus - Lille Vega (Small Hall)"},
      %Upcoming.Venue{id: 487_526, name: "Huset-KBH"},
      %Upcoming.Venue{id: 32906, name: "Musikcaféen"},
      %Upcoming.Venue{id: 1_287_971, name: "Kb18"},
      %Upcoming.Venue{id: 54797, name: "Studenterhuset"},
      %Upcoming.Venue{id: 878_476, name: "Kulturhuset Islands Brygge"},
      %Upcoming.Venue{id: 44329, name: "Valbyhallen"},
      %Upcoming.Venue{id: 1_540_388, name: "Stor Sal (Kransalen), Pumpehuset"},
      %Upcoming.Venue{id: 783_411, name: "Den Sorte Diamant"},
      %Upcoming.Venue{id: 34270, name: "Telia Parken"},
      %Upcoming.Venue{id: 583_056, name: "Koncerthuset, Koncertsalen"},
      %Upcoming.Venue{id: 69299, name: "Huset"},
      %Upcoming.Venue{id: 54162, name: "Den Grå Hal"},
      %Upcoming.Venue{id: 1_500_938, name: "Lille Sal (Sort Sal), Pumpehuset"},
      %Upcoming.Venue{id: 2_564_809, name: "Byhaven, Pumpehuset"},
      %Upcoming.Venue{id: 3_756_504, name: "Alice"},
      %Upcoming.Venue{id: 4_179_174, name: "Vega - Musikkens Hus, Store Vega"},
      %Upcoming.Venue{id: 4_179_234, name: "Ideal Bar, Vega - Musikkens Hus"}
    ]
  end

  def index(conn, _params) do
    render(conn, "index.html", venues: copenhagen_venues())
  end
end
