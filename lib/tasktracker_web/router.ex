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
  end

  # Other scopes may use custom stacks.
  # scope "/api", TasktrackerWeb do
  #   pipe_through :api
  # end
end
