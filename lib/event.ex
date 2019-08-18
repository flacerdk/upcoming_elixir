defmodule Event do
  defstruct [:artist, :date]

  def parse(%{
        "performance" => [%{"artist" => %{"displayName" => name}} | _],
        "start" => %{"date" => date}
      }) do
    %Event{
      artist: name,
      date:
        case Date.from_iso8601(date) do
          {:ok, dt} -> dt
          _ -> nil
        end
    }
  end
end
