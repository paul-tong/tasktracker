defmodule Tasktracker.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.Social.Task
  alias Tasktracker.Social.Manage
  alias Tasktracker.Social.Timeblock

  @doc """
  edit the timeblock
  """
  def edit_timeblock(id, start, stop) do
    timeblock = get_timeblock!(id)
    attrs = %{start_time: start, stop_time: stop}
    update_timeblock(timeblock, attrs)
  end

  @doc """
  Returns the list of timeblocks that of given task
  """
  def list_checking_timeblocks(id) do
    Repo.all(from t in Timeblock, where: t.task_id == ^id)
  end


  @doc """
  Returns the list of underling_id that are managed by given id.
  """
  def list_managed_ids(id) do
    Repo.all(from m in Manage, where: m.manager_id == ^id, select: m.underling_id)
  end

  @doc """
  Returns the list of manager_id that are managing given id.
  """
  def list_manager_ids(id) do
    Repo.all(from m in Manage, where: m.underling_id == ^id, select: m.manager_id)
  end

  @doc """
  Delete the manage record with given manager_id and underling_id
  """
  def my_delete_manage(mid, uid) do
    manage = Repo.one(from m in Manage, where: m.manager_id == ^mid and m.underling_id == ^uid)
    Repo.delete(manage)
  end


  @doc """
  Returns the list of all assigned tasks created by given user id.
  """
  def list_assigned_tasks(id) do
    Repo.all(from t in Task, where: t.user_id_create == ^id and not is_nil(t.user_id_assign))
  end

  @doc """
  Returns the list of unassigned tasks created by given user id.
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






  @doc """
  Returns the list of manages.

  ## Examples

      iex> list_manages()
      [%Manage{}, ...]

  """
  def list_manages do
    Repo.all(Manage)
  end

  @doc """
  Gets a single manage.

  Raises `Ecto.NoResultsError` if the Manage does not exist.

  ## Examples

      iex> get_manage!(123)
      %Manage{}

      iex> get_manage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manage!(id), do: Repo.get!(Manage, id)

  @doc """
  Creates a manage.

  ## Examples

      iex> create_manage(%{field: value})
      {:ok, %Manage{}}

      iex> create_manage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manage(attrs \\ %{}) do
    %Manage{}
    |> Manage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manage.

  ## Examples

      iex> update_manage(manage, %{field: new_value})
      {:ok, %Manage{}}

      iex> update_manage(manage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manage(%Manage{} = manage, attrs) do
    manage
    |> Manage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manage.

  ## Examples

      iex> delete_manage(manage)
      {:ok, %Manage{}}

      iex> delete_manage(manage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manage(%Manage{} = manage) do
    Repo.delete(manage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manage changes.

  ## Examples

      iex> change_manage(manage)
      %Ecto.Changeset{source: %Manage{}}

  """
  def change_manage(%Manage{} = manage) do
    Manage.changeset(manage, %{})
  end



  @doc """
  Returns the list of timeblocks.

  ## Examples

      iex> list_timeblocks()
      [%Timeblock{}, ...]

  """
  def list_timeblocks do
    Repo.all(Timeblock)
  end

  @doc """
  Gets a single timeblock.

  Raises `Ecto.NoResultsError` if the Timeblock does not exist.

  ## Examples

      iex> get_timeblock!(123)
      %Timeblock{}

      iex> get_timeblock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timeblock!(id), do: Repo.get!(Timeblock, id)

  @doc """
  Creates a timeblock.

  ## Examples

      iex> create_timeblock(%{field: value})
      {:ok, %Timeblock{}}

      iex> create_timeblock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timeblock(attrs \\ %{}) do
    %Timeblock{}
    |> Timeblock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timeblock.

  ## Examples

      iex> update_timeblock(timeblock, %{field: new_value})
      {:ok, %Timeblock{}}

      iex> update_timeblock(timeblock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timeblock(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> Timeblock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timeblock.

  ## Examples

      iex> delete_timeblock(timeblock)
      {:ok, %Timeblock{}}

      iex> delete_timeblock(timeblock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timeblock(%Timeblock{} = timeblock) do
    Repo.delete(timeblock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timeblock changes.

  ## Examples

      iex> change_timeblock(timeblock)
      %Ecto.Changeset{source: %Timeblock{}}

  """
  def change_timeblock(%Timeblock{} = timeblock) do
    Timeblock.changeset(timeblock, %{})
  end
end
