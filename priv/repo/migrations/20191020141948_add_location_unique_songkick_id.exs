defmodule Upcoming.Repo.Migrations.AddLocationUniqueSongkickId do
  use Ecto.Migration

  def change do
    create unique_index(:locations, [:songkick_id])
  end
end
