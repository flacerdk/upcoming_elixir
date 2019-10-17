defmodule Upcoming.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :songkick_id, :string
      add :name, :string
      add :location_id, references(:locations)
    end

    create unique_index(:venues, [:songkick_id])
  end
end
