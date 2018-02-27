defmodule Tasktracker.SocialTest do
  use Tasktracker.DataCase

  alias Tasktracker.Social

  describe "tasks" do
    alias Tasktracker.Social.Task

    @valid_attrs %{descrip: "some descrip", isCompleted: true, time: 42, title: "some title", user_id_assign: 42, user_id_create: 42}
    @update_attrs %{descrip: "some updated descrip", isCompleted: false, time: 43, title: "some updated title", user_id_assign: 43, user_id_create: 43}
    @invalid_attrs %{descrip: nil, isCompleted: nil, time: nil, title: nil, user_id_assign: nil, user_id_create: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Social.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Social.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Social.create_task(@valid_attrs)
      assert task.descrip == "some descrip"
      assert task.isCompleted == true
      assert task.time == 42
      assert task.title == "some title"
      assert task.user_id_assign == 42
      assert task.user_id_create == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Social.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.descrip == "some updated descrip"
      assert task.isCompleted == false
      assert task.time == 43
      assert task.title == "some updated title"
      assert task.user_id_assign == 43
      assert task.user_id_create == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_task(task, @invalid_attrs)
      assert task == Social.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Social.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Social.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Social.change_task(task)
    end
  end

  describe "manages" do
    alias Tasktracker.Social.Manage

    @valid_attrs %{manager_id: 42, underling_id: 42}
    @update_attrs %{manager_id: 43, underling_id: 43}
    @invalid_attrs %{manager_id: nil, underling_id: nil}

    def manage_fixture(attrs \\ %{}) do
      {:ok, manage} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_manage()

      manage
    end

    test "list_manages/0 returns all manages" do
      manage = manage_fixture()
      assert Social.list_manages() == [manage]
    end

    test "get_manage!/1 returns the manage with given id" do
      manage = manage_fixture()
      assert Social.get_manage!(manage.id) == manage
    end

    test "create_manage/1 with valid data creates a manage" do
      assert {:ok, %Manage{} = manage} = Social.create_manage(@valid_attrs)
      assert manage.manager_id == 42
      assert manage.underling_id == 42
    end

    test "create_manage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_manage(@invalid_attrs)
    end

    test "update_manage/2 with valid data updates the manage" do
      manage = manage_fixture()
      assert {:ok, manage} = Social.update_manage(manage, @update_attrs)
      assert %Manage{} = manage
      assert manage.manager_id == 43
      assert manage.underling_id == 43
    end

    test "update_manage/2 with invalid data returns error changeset" do
      manage = manage_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_manage(manage, @invalid_attrs)
      assert manage == Social.get_manage!(manage.id)
    end

    test "delete_manage/1 deletes the manage" do
      manage = manage_fixture()
      assert {:ok, %Manage{}} = Social.delete_manage(manage)
      assert_raise Ecto.NoResultsError, fn -> Social.get_manage!(manage.id) end
    end

    test "change_manage/1 returns a manage changeset" do
      manage = manage_fixture()
      assert %Ecto.Changeset{} = Social.change_manage(manage)
    end
  end

  describe "timeblocks" do
    alias Tasktracker.Social.Timeblock

    @valid_attrs %{start_time: "some start_time", stop_time: "some stop_time", task_id: 42}
    @update_attrs %{start_time: "some updated start_time", stop_time: "some updated stop_time", task_id: 43}
    @invalid_attrs %{start_time: nil, stop_time: nil, task_id: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert Social.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert Social.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = Social.create_timeblock(@valid_attrs)
      assert timeblock.start_time == "some start_time"
      assert timeblock.stop_time == "some stop_time"
      assert timeblock.task_id == 42
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = Social.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.start_time == "some updated start_time"
      assert timeblock.stop_time == "some updated stop_time"
      assert timeblock.task_id == 43
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == Social.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = Social.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> Social.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = Social.change_timeblock(timeblock)
    end
  end
end
