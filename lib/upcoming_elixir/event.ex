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

  def parse(%{
        "id" => event_songkick_id,
        "performance" => performance,
        "start" => %{"date" => date},
        "venue" => %{
          "displayName" => venue_name,
          "id" => venue_songkick_id,
          "metroArea" => %{
            "displayName" => location_name,
            "id" => location_songkick_id
          }
        }
      }) do
    artist =
      case performance do
        [%{"artist" => %{"displayName" => name}} | _] -> name
        _ -> nil
      end

    %{
      event: %{
        songkick_id: to_string(event_songkick_id),
        artist: artist,
        date:
          case Date.from_iso8601(date) do
            {:ok, dt} -> dt
            _ -> nil
          end
      },
      venue: %{
        songkick_id: to_string(venue_songkick_id),
        name: venue_name
      },
      location: %{
        songkick_id: to_string(location_songkick_id),
        name: location_name
      }
    }
  end
end
