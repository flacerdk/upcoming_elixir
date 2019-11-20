defmodule Upcoming.Venue do
  use Ecto.Schema

  schema "venues" do
    field :songkick_id, :string
    field :name, :string
    belongs_to(:location, Upcoming.Location)
    has_many(:events, Upcoming.Event)
  end

  def changeset(venue, params \\ %{}) do
    venue
    |> Ecto.Changeset.cast(params, [:songkick_id, :name, :location_id])
    |> Ecto.Changeset.validate_required([:songkick_id, :name, :location_id])
    |> Ecto.Changeset.unique_constraint(:songkick_id)
  end
end
