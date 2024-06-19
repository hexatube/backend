defmodule Hexatube.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :like, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :video_id, references(:videos, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
