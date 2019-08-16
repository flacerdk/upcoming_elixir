defmodule Fetch do
  defp base_url do
    api_key = Application.get_env(:upcoming_elixir, :APIKey)

    URI.parse("https://api.songkick.com/api/3.0")
    |> Map.put(:query, URI.encode_query(%{"apikey" => api_key}))
  end

  defp append_url(relative_url, base \\ base_url()) do
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

    response
  end

  def fetch_json(relative_url, page \\ 1, per_page \\ 50) do
    response = fetch(relative_url, page, per_page)

    %{"resultsPage" => %{"results" => results, "totalEntries" => total_entries}} =
      Poison.decode!(response.body)

    %{:results => results, :max => total_entries}
  end
end
