defmodule Tasktracker.SoSocialTest do
  use Tasktracker.DataCase

  alias Tasktracker.SoSocial

  describe "timeblocks" do
    alias Tasktracker.SoSocial.Timeblock

    @valid_attrs %{start_time: "some start_time", stop_time: "some stop_time", task_id: 42}
    @update_attrs %{start_time: "some updated start_time", stop_time: "some updated stop_time", task_id: 43}
    @invalid_attrs %{start_time: nil, stop_time: nil, task_id: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SoSocial.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert SoSocial.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert SoSocial.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = SoSocial.create_timeblock(@valid_attrs)
      assert timeblock.start_time == "some start_time"
      assert timeblock.stop_time == "some stop_time"
      assert timeblock.task_id == 42
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SoSocial.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = SoSocial.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.start_time == "some updated start_time"
      assert timeblock.stop_time == "some updated stop_time"
      assert timeblock.task_id == 43
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = SoSocial.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == SoSocial.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = SoSocial.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> SoSocial.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = SoSocial.change_timeblock(timeblock)
    end
  end
end
