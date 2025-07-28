defmodule Piruet.MusicFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Piruet.Music` context.
  """

  @doc """
  Generate a queue.
  """
  def queue_fixture(attrs \\ %{}) do
    {:ok, queue} =
      attrs
      |> Enum.into(%{
        status: "some status",
        tracks: "some tracks",
        url: "some url"
      })
      |> Piruet.Music.create_queue()

    queue
  end
end
