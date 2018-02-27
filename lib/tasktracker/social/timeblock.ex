defmodule Tasktracker.Social.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Social.Timeblock


  schema "timeblocks" do
    field :start_time, :string
    field :stop_time, :string
    field :task_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:task_id, :start_time, :stop_time])
    |> validate_required([:task_id, :start_time, :stop_time])
  end
end
