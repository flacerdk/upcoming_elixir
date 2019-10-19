defmodule Upcoming.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string
    has_many(:venues, Upcoming.Venue)

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def events(location) do
    import Ecto.Query, only: [from: 2]

    from(l in Upcoming.Location,
      where: l.id == ^location.id,
      left_join: venues in assoc(l, :venues),
      left_join: events in assoc(venues, :events),
      preload: [venues: {venues, events: events}]
    )
    |> Upcoming.Repo.one()
    |> Map.get(:venues)
    |> Enum.flat_map(fn %Upcoming.Venue{events: events} -> events end)
  end
end
