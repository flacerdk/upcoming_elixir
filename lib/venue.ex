defmodule Venue do
  defstruct [:id, :name]

  def parse(%{"id" => id, "displayName" => name}) do
    %Venue{id: id, name: name}
  end

  def get_from_file(filename) do
    Fetch.fetch_json(filename) |> Enum.map(&parse/1)
  end

  def get_from_location(location, page \\ 1, per_page \\ 50) do
    %{"resultsPage" => %{"results" => results, "totalEntries" => max}} =
      Fetch.fetch_json("/search/venues.json?query=#{location}", page, per_page)

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
    %{"resultsPage" => %{"results" => results}} =
      Fetch.fetch_json("/venues/#{venue_id}/calendar.json")

    case results do
      %{"event" => events} -> Enum.map(events, &Event.parse/1)
      _ -> []
    end
  end
end
