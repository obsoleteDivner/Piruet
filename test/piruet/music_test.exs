defmodule Piruet.MusicTest do
  use Piruet.DataCase

  alias Piruet.Music

  describe "track" do
    alias Piruet.Music.Queue

    import Piruet.MusicFixtures

    @invalid_attrs %{status: nil, url: nil, tracks: nil}

    test "list_track/0 returns all track" do
      queue = queue_fixture()
      assert Music.list_track() == [queue]
    end

    test "get_queue!/1 returns the queue with given id" do
      queue = queue_fixture()
      assert Music.get_queue!(queue.id) == queue
    end

    test "create_queue/1 with valid data creates a queue" do
      valid_attrs = %{status: "some status", url: "some url", tracks: "some tracks"}

      assert {:ok, %Queue{} = queue} = Music.create_queue(valid_attrs)
      assert queue.status == "some status"
      assert queue.url == "some url"
      assert queue.tracks == "some tracks"
    end

    test "create_queue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_queue(@invalid_attrs)
    end

    test "update_queue/2 with valid data updates the queue" do
      queue = queue_fixture()
      update_attrs = %{status: "some updated status", url: "some updated url", tracks: "some updated tracks"}

      assert {:ok, %Queue{} = queue} = Music.update_queue(queue, update_attrs)
      assert queue.status == "some updated status"
      assert queue.url == "some updated url"
      assert queue.tracks == "some updated tracks"
    end

    test "update_queue/2 with invalid data returns error changeset" do
      queue = queue_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_queue(queue, @invalid_attrs)
      assert queue == Music.get_queue!(queue.id)
    end

    test "delete_queue/1 deletes the queue" do
      queue = queue_fixture()
      assert {:ok, %Queue{}} = Music.delete_queue(queue)
      assert_raise Ecto.NoResultsError, fn -> Music.get_queue!(queue.id) end
    end

    test "change_queue/1 returns a queue changeset" do
      queue = queue_fixture()
      assert %Ecto.Changeset{} = Music.change_queue(queue)
    end
  end
end
