defmodule Upcoming.Event do
  use Ecto.Schema

  schema "events" do
    field :artist, :string
    field :date, :date, null: true
    field :songkick_id, :string
    belongs_to(:venue, Upcoming.Venue)
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(params, [:artist, :date, :venue_id, :songkick_id])
    |> Ecto.Changeset.validate_required([:venue_id, :artist, :songkick_id])
    |> Ecto.Changeset.unique_constraint(:songkick_id)
  end

  def parse(venue_id, %{
        "id" => songkick_id,
        "performance" => performance,
        "start" => %{"date" => date}
      }) do
    artist =
      case performance do
        [%{"artist" => %{"displayName" => name}} | _] -> name
        _ -> nil
      end

    %Upcoming.Event{}
    |> Upcoming.Event.changeset(%{
      songkick_id: to_string(songkick_id),
      artist: artist,
      venue_id: venue_id,
      date:
        case Date.from_iso8601(date) do
          {:ok, dt} -> dt
          _ -> nil
        end
    })
    |> Upcoming.Repo.insert!()
  end
end
