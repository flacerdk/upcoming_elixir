defmodule Upcoming.Songkick do
  use Retry

  defp base_url do
    api_key = Application.get_env(:upcoming_elixir, :api_key)

    URI.parse("https://api.songkick.com/api/3.0")
    |> Map.put(:query, URI.encode_query(%{"apikey" => api_key}))
  end

  defp append_url(relative_url, base) do
    %{:path => base_path, :query => base_query} = base
    %{:path => additional_path, :query => additional_query} = relative_url

    query =
      Map.merge(
        URI.decode_query(base_query || ""),
        URI.decode_query(additional_query || "")
      )
      |> URI.encode_query()

    base
    |> Map.put(:path, base_path <> (additional_path || ""))
    |> Map.put(:query, query)
  end

  defp fetch(url, page, per_page) do
    parsed_url = URI.parse(url)

    case parsed_url do
      %{:scheme => "file", :host => file} ->
        {:ok, File.read!(file)}

      _ ->
        retry with: exponential_backoff() |> randomize |> expiry(10_000) do
          Mojito.get(
            append_url(
              URI.parse("?page=#{page}&per_page=#{per_page}"),
              append_url(parsed_url, base_url())
            )
          )
        after
          {:ok, %Mojito.Response{body: body}} -> {:ok, body}
        else
          error -> error
        end
    end
  end

  def fetch_json(relative_url, page \\ 1, per_page \\ 50) do
    response = fetch(relative_url, page, per_page)

    case response do
      {:ok, body} -> Jason.decode!(body)
      _ -> "Error"
    end
  end

  def fetch_venue_calendar(venue_id) do
    %{"resultsPage" => %{"results" => results}} = fetch_json("/venues/#{venue_id}/calendar.json")

    %{results: results}
  end

  def fetch_venues_from_file(filename) do
    fetch_json(filename)
  end

  def fetch_venues_from_location(location, page \\ 1, per_page \\ 50) do
    %{"resultsPage" => %{"results" => results, "totalEntries" => max}} =
      fetch_json("/search/venues.json?query=#{location}", page, per_page)

    %{results: results, max: max}
  end
end
