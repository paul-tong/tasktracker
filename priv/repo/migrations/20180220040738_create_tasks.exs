defmodule Tasktracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :descrip, :text, null: false
      add :user_id_create, :integer, null: false
      add :user_id_assign, :integer
      add :time, :integer
      add :isCompleted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
