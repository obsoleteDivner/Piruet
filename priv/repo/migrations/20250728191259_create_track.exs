defmodule Piruet.Repo.Migrations.CreateTrack do
  use Ecto.Migration

  def change do
    create table(:track) do
      add :tracks, :string
      add :url, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
