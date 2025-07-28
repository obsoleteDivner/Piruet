defmodule Piruet.Music.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "track" do
    field :status, :string
    field :url, :string
    field :tracks, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:tracks, :url, :status])
  end
end
