defmodule Hexatube.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string, null: false
      add :path, :string, null: false
      add :category, :string, null: false
      add :user_id, references(:users), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
