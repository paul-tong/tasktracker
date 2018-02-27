defmodule TasktrackerWeb.ManageView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.ManageView

  def render("index.json", %{manages: manages}) do
    %{data: render_many(manages, ManageView, "manage.json")}
  end

  def render("show.json", %{manage: manage}) do
    %{data: render_one(manage, ManageView, "manage.json")}
  end

  def render("manage.json", %{manage: manage}) do
    %{id: manage.id,
      manager_id: manage.manager_id,
      underling_id: manage.underling_id}
  end
end
