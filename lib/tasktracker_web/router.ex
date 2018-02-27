defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  def get_current_user(conn, _params) do
    # TODO: Move this function out of the router module.
    user_id = get_session(conn, :user_id)
    user = Tasktracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tasks", TaskController do
    end
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    get "/unassigned_tasks", PageController, :unassigned
    get "/assign_task/:id", PageController, :assign
    get "/do_assign/:id", PageController, :do_assign
    get "/uncompleted_tasks", PageController, :uncompleted
    get "/do_complete/:id", PageController, :do_complete
    get "/completed_tasks", PageController, :completed
    get "/edit_time/:id", PageController, :edit_time
    post "/do_edit_time", PageController, :do_edit_time
    get "/begin", PageController, :begin
    get "/manage_list", PageController, :manage_list
    get "/add_underling_list", PageController, :add_underling_list
    get "/add_underling/:id", PageController, :add_underling
    get "/delete_underling/:id", PageController, :delete_underling
    get "/report_tasks", PageController, :report_tasks
    post "add_timeblock", PageController, :add_timeblock
    get "/check_timeblock/:id", PageController, :check_timeblock
    get "/add_timeblock/:id", PageController, :add_timeblock
    get "/delete_timeblock/:id", PageController, :delete_timeblock
    get "/edit_timeblock/:id", PageController, :edit_timeblock
    post "/do_edit_timeblock/:time_id", PageController, :do_edit_timeblock
    get "/view_timeblock/:id", PageController, :view_timeblock
  end

  # Other scopes may use custom stacks.
  scope "/api", TasktrackerWeb do
    pipe_through :api
    resources "/manages", ManageController, except: [:new, :edit]
    resources "/timeblocks", TimeblockController, except: [:new, :edit]
  end
end
