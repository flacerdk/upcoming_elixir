defmodule URL do
  def append(relative_url, base) do
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
end
