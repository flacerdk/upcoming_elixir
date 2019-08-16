defmodule Upcoming do
  @moduledoc """
  Documentation for Upcoming.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Upcoming.hello()
      :world

  """

  def copenhagen_venues do
    [
      4_179_319,
      4_179_234,
      3_756_504,
      54162,
      811_381,
      44268,
      34460,
      2_740_208,
      4_179_379,
      3_723_574,
      1_500_938,
      32939
    ]
  end

  def get_venue_calendar(venue_id) do
    %{"resultsPage" => %{"results" => results}} =
      Fetch.fetch_json("/venues/#{venue_id}/calendar.json")

    case results do
      %{"event" => events} -> events
      _ -> []
    end
  end

  def get_venues(location, page \\ 1, per_page \\ 50) do
    %{"resultsPage" => %{"results" => results, "totalEntries" => max}} =
      Fetch.fetch_json("/search/venues.json?query=#{location}", page, per_page)

    case results do
      %{"venue" => venues} ->
        if (page - 1) * length(venues) >= max do
          venues
        else
          venues ++ get_venues(location, page + 1, per_page)
        end

      _ ->
        []
    end
  end
end
