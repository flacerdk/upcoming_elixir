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

  def venues do
    [4179319, 4179234, 3756504, 54162, 811381, 44268, 34460, 2740208, 4179379, 3723574, 1500938, 32939]
  end

  def base_url do
    api_key = Application.get_env(:upcoming_elixir, :APIKey)
    URI.parse("https://api.songkick.com/api/3.0")
    |> Map.put(:query, URI.encode_query(%{"apikey" => api_key}))
  end

  def append_url(relative_url) do
    %{:path => base_path, :query => base_query} = base_url()
    %{:path => additional_path, :query => additional_query} = URI.parse(relative_url)
    query = Map.merge(
      URI.decode_query(base_query || ""),
      URI.decode_query(additional_query || "")
    )
    |> URI.encode_query

    base_url()
    |> Map.put(:path, base_path <> additional_path)
    |> Map.put(:query, query)
  end

  def fetch(relative_url) do
    {:ok, response} = append_url(relative_url) |> Mojito.get
    Poison.decode!(response.body)
    |> Map.get("resultsPage")
    |> Map.get("results")
    |> Map.get("event")
  end

  def get_venue_calendar(venue_id) do
    fetch("/venues/#{venue_id}/calendar.json")
  end
end
