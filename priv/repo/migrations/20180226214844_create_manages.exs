defmodule Tasktracker.Repo.Migrations.CreateManages do
  use Ecto.Migration

  def change do
    create table(:manages) do
      add :manager_id, :integer
      add :underling_id, :integer

      timestamps()
    end

  end
end
