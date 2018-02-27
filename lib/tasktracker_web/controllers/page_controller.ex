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
    current_id = conn.assigns[:current_user].id
    underling_ids = Tasktracker.Social.list_managed_ids(current_id) # underlings managed by current user
    underlings = Tasktracker.Accounts.list_users()
    |> Enum.filter(fn(x) -> Enum.member?(underling_ids, x.id) end) # transfer ids to users
    conn
    |> put_session(:current_task_id, id)
    |> render("assign.html", task: task, users: underlings)
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
    conn
    |> put_flash(:info, "You just finished a task!")
    |> render("uncompleted.html", tasks: tasks)
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

  # render to begin page
  def begin(conn, _params) do
    conn
    |> render("begin.html")
  end


  # render to manage page, show management information
  def manage_list(conn, _params) do
    current_id = conn.assigns[:current_user].id
    manager_ids = Tasktracker.Social.list_manager_ids(current_id) # managers that manage current user
    managers = Tasktracker.Accounts.list_users()
    |> Enum.filter(fn(x) -> Enum.member?(manager_ids, x.id) end) # transfer ids to users
    
    underling_ids = Tasktracker.Social.list_managed_ids(current_id) # underlings managed by current user
    underlings = Tasktracker.Accounts.list_users()
    |> Enum.filter(fn(x) -> Enum.member?(underling_ids, x.id) end) # transfer ids to users

    conn
    |> render("manage.html", managers: managers, underlings: underlings)
  end


  # render add_underling page, show all the potential underlings
  def add_underling_list(conn, _params) do
    manager_id = conn.assigns[:current_user].id
    user_ids = Tasktracker.Social.list_managed_ids(manager_id) # user_ids managed by current user
    users = Tasktracker.Accounts.list_users() # all the users
    |> Enum.filter(fn(x) -> !Enum.member?(user_ids, x.id) end) # users that are not managed
    conn
    |> render("add_underling_list.html", users: users)
  end

  # add given underling to given manager
  def add_underling(conn, _params) do
    manager_id = conn.assigns[:current_user].id
    underling_id = _params["id"]
    attrs = %{manager_id: manager_id, underling_id: underling_id}
    add = Tasktracker.Social.create_manage(attrs) # create a new management record
    conn
    |> put_flash(:info, "Add underling success!")
    |> redirect(to: "/manage_list", method: :get)
  end

  # delete given underling from given manager
  def delete_underling(conn, _params) do
    manager_id = conn.assigns[:current_user].id
    underling_id = String.to_integer(_params["id"])
    delete = Tasktracker.Social.my_delete_manage(manager_id, underling_id) # delete a management record
    conn
    |> put_flash(:info, "Delete underling success!")
    |> redirect(to: "/manage_list", method: :get)
  end

  # get task report of current_user
  def report_tasks(conn, _params) do
    id = conn.assigns[:current_user].id
    tasks = Tasktracker.Social.list_assigned_tasks(id) # tasks assigned by current user
    render(conn, "report_tasks.html", tasks: tasks)
  end

  # check timeblocks of given task id
  def check_timeblock(conn, _params) do
    task_id = _params["id"]
    task = Tasktracker.Social.get_task!(task_id)
    timeblocks = Tasktracker.Social.list_checking_timeblocks(task_id) # timeblocks of given task
    render(conn, "check_timeblocks.html", task: task, timeblocks: timeblocks)
  end

  # delete given timeblock
  def delete_timeblock(conn, _params) do
    time_id = String.to_integer(_params["id"])
    timeblock = Tasktracker.Social.get_timeblock!(time_id)
    task_id = timeblock.task_id
    delete = Tasktracker.Social.delete_timeblock(timeblock) # delete a timeblock
    conn
    |> put_flash(:info, "Delete timeblock success!")
    |> redirect(to: "/check_timeblock/"<>Integer.to_string(task_id), method: :get)
  end

  # edit given timeblock
  def edit_timeblock(conn, _params) do
    time_id = String.to_integer(_params["id"])
    timeblock = Tasktracker.Social.get_timeblock!(time_id)
    task = Tasktracker.Social.get_task!(timeblock.task_id)
    conn
    |> render("editTimeblock.html", task: task, timeblock: timeblock)
  end

  # do edit time block
  def do_edit_timeblock(conn, %{"time_id"=> time_id, "start" => start, "stop" => stop}) do
    info = Tasktracker.Social.edit_timeblock(time_id, start, stop)
    timeblock = Tasktracker.Social.get_timeblock!(time_id)
    task_id = timeblock.task_id
    conn 
    |> put_flash(:info, "edit timeblock success")
    |> redirect(to: "/check_timeblock/"<>Integer.to_string(task_id), method: :get)
  end

  # view timeblocks of given task id (cannot edit and delete)
  def view_timeblock(conn, _params) do
    task_id = _params["id"]
    task = Tasktracker.Social.get_task!(task_id)
    timeblocks = Tasktracker.Social.list_checking_timeblocks(task_id) # timeblocks of given task
    render(conn, "view_timeblocks.html", task: task, timeblocks: timeblocks)
  end

end
