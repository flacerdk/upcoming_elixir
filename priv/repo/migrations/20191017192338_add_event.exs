defmodule Upcoming.Repo.Migrations.AddEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :artist, :string
      add :date, :date
      add :venue_id, references(:venues)
    end
  end
end
