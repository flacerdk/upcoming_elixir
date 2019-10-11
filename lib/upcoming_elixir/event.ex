defmodule Upcoming.Event do
  @derive {Jason.Encoder, only: [:artist, :date]}
  defstruct [:artist, :date]

  def parse(%{
        "performance" => performance,
        "start" => %{"date" => date}
      }) do
    artist =
      case performance do
        [%{"artist" => %{"displayName" => name}} | _] -> name
        _ -> nil
      end

    %Upcoming.Event{
      artist: artist,
      date:
        case Date.from_iso8601(date) do
          {:ok, dt} -> dt
          _ -> nil
        end
    }
  end
end
