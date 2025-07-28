defmodule Piruet.Music do
  @moduledoc """
  The Music context.
  """

  import Ecto.Query, warn: false
  alias Piruet.Repo

  alias Piruet.Music.Track

  def list_track do
    Repo.all(Track)
  end

  def get_track!(id), do: Repo.get!(Track, id)

  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end


  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end


  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  def change_track(%Track{} = track, attrs \\ %{}) do
    Track.changeset(track, attrs)
  end
end
