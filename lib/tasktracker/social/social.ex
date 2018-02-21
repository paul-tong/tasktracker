defmodule Tasktracker.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.Social.Task

  @doc """
  Returns the list of tasks created by given user id.
  """
  def list_unassigned_tasks(id) do
    Repo.all(from t in Task, where: t.user_id_create == ^id and is_nil(t.user_id_assign))
  end

  @doc """
  Returns the list of uncompleted tasks of this user
  """
  def list_uncompleted_tasks(id) do
    Repo.all(from t in Task, where: t.user_id_assign == ^id and t.isCompleted == false)
  end

  @doc """
  Returns the list of completed tasks of this user
  """
  def list_completed_tasks(id) do
    Repo.all(from t in Task, where: t.user_id_assign == ^id and t.isCompleted == true)
  end

  @doc """
  Assign the task with given id to the given user.
  """
  def assign_task(task_id, user_id) do
    task = get_task!(task_id)
    attrs = %{user_id_assign: user_id}
    update_task(task, attrs)
  end

  @doc """
  Complete the given task
  """
  def complete_task(task_id) do
    task = get_task!(task_id)
    attrs = %{isCompleted: true}
    update_task(task, attrs)
  end


  @doc """
  set the spent time of given task
  """
  def edit_time(task_id, time) do
    task = get_task!(task_id)
    attrs = %{time: time}
    update_task(task, attrs)
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
