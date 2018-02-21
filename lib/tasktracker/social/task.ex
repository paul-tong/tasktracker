defmodule Tasktracker.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Social.Task


  schema "tasks" do
    field :title, :string
    field :descrip, :string
    field :isCompleted, :boolean, default: false
    field :time, :integer, default: 0
    field :user_id_assign, :integer
    field :user_id_create, :integer

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :descrip, :user_id_create, :user_id_assign, :time, :isCompleted])
    |> validate_required([:title, :descrip, :user_id_create])
    |> validate_number(:time,  greater_than_or_equal_to: 0)
  end
end
