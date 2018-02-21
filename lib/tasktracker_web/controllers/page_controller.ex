defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # get all unassigned tasks created by current_user
  def unassigned(conn, _params) do
    id = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_unassigned_tasks(id)
    render conn, "unassigned.html", tasks: tasks
  end

  # list all users to choose 
  def assign(conn, _params) do
    id = _params["id"]
    task = Tasktracker.Social.get_task!(id)
    users = Tasktracker.Accounts.list_users()
    conn
    |> put_session(:current_task_id, id)
    |> render("assign.html", task: task, users: users)
  end

  # do assign to a specific user
  def do_assign(conn, _params) do
    task_id = get_session(conn, :current_task_id)
    user_id = _params["id"]
    info = Tasktracker.Social.assign_task(task_id, user_id)
    current_user = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_unassigned_tasks(current_user)
    render conn, "unassigned.html", tasks: tasks
  end

  # get all uncompleted tasks of current_user
  def uncompleted(conn, _params) do
    id = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_uncompleted_tasks(id)
    render conn, "uncompleted.html", tasks: tasks
  end

  # complete a task
  def do_complete(conn, _params) do
    task_id = _params["id"]
    user_id = conn.assigns[:current_user].id
    info = Tasktracker.Social.complete_task(task_id)
    tasks = Tasktracker.Social.list_uncompleted_tasks(user_id)
    render conn, "uncompleted.html", tasks: tasks
  end

  # get all completed tasks of current_user
  def completed(conn, _params) do
    id = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_completed_tasks(id)
    render conn, "completed.html", tasks: tasks
  end

  # edit time spent on a task
  def edit_time(conn, _params) do
    task_id = _params["id"]
    task = Tasktracker.Social.get_task!(task_id)
    changeset = Tasktracker.Social.change_task(task)
    conn
    |> put_session(:current_task_id, task_id)
    |> render("editTime.html", task: task, changeset: changeset)
  end

  # do edit time spent on a task
  def do_edit_time(conn, %{"time" => time}) do
    time_int = String.to_integer(time)
    task_id = get_session(conn, :current_task_id)
    user_id = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_uncompleted_tasks(user_id)
    if rem(time_int, 15) == 0 && time_int >= 0 do
      info = Tasktracker.Social.edit_time(task_id, time)
      tasks = Tasktracker.Social.list_uncompleted_tasks(user_id)
      conn 
      |> put_flash(:info, "edit time success")
      |> render("uncompleted.html", tasks: tasks)
    else
      conn 
      |> put_flash(:info, "time must >= 0 and be 15m increments")
      |> render("uncompleted.html", tasks: tasks)
    end
  end

end
