defmodule TasktrackerWeb.TimeblockView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimeblockView

  def render("index.json", %{timeblocks: timeblocks}) do
    %{data: render_many(timeblocks, TimeblockView, "timeblock.json")}
  end

  def render("show.json", %{timeblock: timeblock}) do
    %{data: render_one(timeblock, TimeblockView, "timeblock.json")}
  end

  def render("timeblock.json", %{timeblock: timeblock}) do
    %{id: timeblock.id,
      task_id: timeblock.task_id,
      start_time: timeblock.start_time,
      stop_time: timeblock.stop_time}
  end
end
