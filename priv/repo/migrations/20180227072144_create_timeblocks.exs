defmodule Tasktracker.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :task_id, :integer
      add :start_time, :string
      add :stop_time, :string

      timestamps()
    end

  end
end
