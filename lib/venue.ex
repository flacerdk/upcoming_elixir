defmodule Venue do
  defstruct [:id, :name]

  def parse(%{"id" => id, "displayName" => name}) do
    %Venue{id: id, name: name}
  end

  def get_from_file(filename) do
    Songkick.fetch_venues_from_file(filename) |> Enum.map(&parse/1)
  end

  def get_from_location(location, page \\ 1, per_page \\ 50) do
    %{results: results, max: max} = Songkick.fetch_venues_from_location(location, page, per_page)

    case results do
      %{"venue" => venues} ->
        parsed_venues = Enum.map(venues, &parse/1)

        if (page - 1) * length(venues) >= max do
          parsed_venues
        else
          parsed_venues ++ get_from_location(location, page + 1, per_page)
        end

      _ ->
        []
    end
  end

  def get_calendar(%Venue{id: venue_id}) do
    case Songkick.fetch_venue_calendar(venue_id) do
      %{"event" => events} -> Enum.map(events, &Event.parse/1)
      _ -> []
    end
  end

  def get_all_calendars(venues) do
    Enum.flat_map(venues, fn v ->
      calendar = get_calendar(v)

      :timer.sleep(3000)
      calendar
    end)
  end
end
