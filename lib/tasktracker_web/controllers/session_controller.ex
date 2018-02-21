defmodule TasktrackerWeb.SessionController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.User

  def create(conn, %{"username" => name}) do
    user = Accounts.get_user_by_name(name)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: user_path(conn, :index)) 
    else
      conn
      |> put_flash(:error, "User does not exist")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end

