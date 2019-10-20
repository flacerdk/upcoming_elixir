defmodule Mix.Tasks.UpdateEvents do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start", [])

    Upcoming.Repo.all(Upcoming.Location)
    |> Enum.each(fn l ->
      Upcoming.Location.fetch_events(l)
      :timer.sleep(3000)
    end)
  end
end
