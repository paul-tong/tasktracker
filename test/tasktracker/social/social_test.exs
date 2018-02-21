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
end
