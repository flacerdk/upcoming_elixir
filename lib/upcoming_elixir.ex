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

  def base_url do
    api_key = Application.get_env(:upcoming_elixir, :APIKey)

    URI.parse("https://api.songkick.com/api/3.0")
    |> Map.put(:query, URI.encode_query(%{"apikey" => api_key}))
  end

  def append_url(relative_url, base \\ base_url()) do
    %{:path => base_path, :query => base_query} = base
    %{:path => additional_path, :query => additional_query} = URI.parse(relative_url)

    query =
      Map.merge(
        URI.decode_query(base_query || ""),
        URI.decode_query(additional_query || "")
      )
      |> URI.encode_query()

    base_url()
    |> Map.put(:path, base_path <> (additional_path || ""))
    |> Map.put(:query, query)
  end

  def fetch(relative_url, page \\ 1, per_page \\ 50) do
    {:ok, response} =
      append_url("?page=#{page}&per_page=#{per_page}", append_url(relative_url)) |> Mojito.get()

    %{"resultsPage" => %{"results" => results, "totalEntries" => total_entries}} =
      Poison.decode!(response.body)

    %{:results => results, :max => total_entries}
  end

  def get_venue_calendar(venue_id) do
    %{:results => %{"event" => events}} = fetch("/venues/#{venue_id}/calendar.json")
    events
  end

  def get_venues(location, page \\ 1, per_page \\ 50) do
    %{:results => results, :max => max} =
      fetch("/search/venues.json?query=#{location}", page, per_page)

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
