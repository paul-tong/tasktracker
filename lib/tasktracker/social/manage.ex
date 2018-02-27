defmodule Tasktracker.Social.Manage do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Social.Manage


  schema "manages" do
    field :manager_id, :integer
    field :underling_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Manage{} = manage, attrs) do
    manage
    |> cast(attrs, [:manager_id, :underling_id])
    |> validate_required([:manager_id, :underling_id])
  end
end
