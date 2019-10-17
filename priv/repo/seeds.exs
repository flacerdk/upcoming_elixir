# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Upcoming.Repo.insert!(%Upcoming.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

copenhagen = %{id: "28617", name: "Copenhagen"}

copenhagen_venues = [
  %{id: "44268", name: "Loppen"},
  %{id: "2740208", name: "Vega"},
  %{id: "32939", name: "Pumpehuset"},
  %{id: "34658", name: "Amager Bio"},
  %{id: "66914", name: "Jazzhus Montmartre"},
  %{id: "783451", name: "Bremen"},
  %{id: "81192", name: "Ungdomshuset"},
  %{id: "629926", name: "Forum"},
  %{id: "3723574", name: "Hotel Cecil"},
  %{id: "34460", name: "KB Hallen"},
  %{id: "2543124", name: "Vega Musikkens Hus - Lille Vega (Small Hall)"},
  %{id: "487526", name: "Huset-KBH"},
  %{id: "32906", name: "Musikcaféen"},
  %{id: "1287971", name: "Kb18"},
  %{id: "54797", name: "Studenterhuset"},
  %{id: "878476", name: "Kulturhuset Islands Brygge"},
  %{id: "44329", name: "Valbyhallen"},
  %{id: "1540388", name: "Stor Sal (Kransalen), Pumpehuset"},
  %{id: "783411", name: "Den Sorte Diamant"},
  %{id: "34270", name: "Telia Parken"},
  %{id: "583056", name: "Koncerthuset, Koncertsalen"},
  %{id: "69299", name: "Huset"},
  %{id: "54162", name: "Den Grå Hal"},
  %{id: "1500938", name: "Lille Sal (Sort Sal), Pumpehuset"},
  %{id: "2564809", name: "Byhaven, Pumpehuset"},
  %{id: "3756504", name: "Alice"},
  %{id: "4179174", name: "Vega - Musikkens Hus, Store Vega"},
  %{id: "4179234", name: "Ideal Bar, Vega - Musikkens Hus"}
]

copenhagen_struct =
  %Upcoming.Location{}
  |> Upcoming.Location.changeset(%{
    songkick_id: copenhagen.id,
    name: copenhagen.name
  })
  |> Upcoming.Repo.insert!()

Enum.each(copenhagen_venues, fn %{id: songkick_id, name: name} ->
  Upcoming.Venue.changeset(%Upcoming.Venue{}, %{
    songkick_id: songkick_id,
    name: name,
    location_id: copenhagen_struct.id
  })
  |> Upcoming.Repo.insert!()
end)
