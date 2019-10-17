defmodule Upcoming.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :songkick_id, :string
      add :name, :string

      timestamps()
    end
  end
end
