defmodule Upcoming.Songkick do
  use Retry

  defp base_url do
    api_key = Application.get_env(:upcoming_elixir, :api_key)

    URI.parse("https://api.songkick.com/api/3.0")
    |> Map.put(:query, URI.encode_query(%{"apikey" => api_key}))
  end

  defp fetch(url, page, per_page) do
    parsed_url = URI.parse(url)

    case parsed_url do
      %{:scheme => "file", :host => file} ->
        {:ok, File.read!(file)}

      _ ->
        retry with: exponential_backoff() |> randomize |> expiry(10_000) do
          Mojito.get(
            URL.append(
              URI.parse("?page=#{page}&per_page=#{per_page}"),
              URL.append(parsed_url, base_url())
            )
          )
        after
          {:ok, %Mojito.Response{body: body}} -> {:ok, body}
        else
          error -> error
        end
    end
  end

  defp fetch_json(relative_url, page \\ 1, per_page \\ 50) do
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
