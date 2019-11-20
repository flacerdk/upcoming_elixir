defmodule Upcoming.Location do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "locations" do
    field :name, :string
    field :songkick_id, :string
    has_many(:venues, Upcoming.Venue)

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :songkick_id])
    |> validate_required([:name, :songkick_id])
    |> Ecto.Changeset.unique_constraint(:songkick_id)
  end

  def venues_with_events(location) do
    Upcoming.Repo.all(
      from v in Upcoming.Venue, where: ^location.id == v.location_id, preload: [:events]
    )
    |> Enum.filter(fn v -> length(v.events) > 0 end)
  end

  defp fetch_or_insert(schema, payload) do
    case Upcoming.Repo.one(from row in schema, where: row.songkick_id == ^payload.songkick_id) do
      nil ->
        struct(schema, payload)
        |> Upcoming.Repo.insert!()

      row ->
        row
    end
  end

  defp insert_event(payload) do
    %{event: event_struct, venue: venue_struct, location: location_struct} =
      Upcoming.Event.parse(payload)

    location = fetch_or_insert(Upcoming.Location, location_struct)
    venue = fetch_or_insert(Upcoming.Venue, Map.put(venue_struct, :location_id, location.id))
    event = fetch_or_insert(Upcoming.Event, Map.put(event_struct, :venue_id, venue.id))

    event
  end

  def fetch_events(location) do
    %{"resultsPage" => %{"results" => %{"event" => events}}} =
      Upcoming.Songkick.fetch_location_calendar(location.songkick_id)

    Enum.map(events, &insert_event/1)
  end
end
