defmodule Hexatube.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :path, :string
      add :category, :string

      timestamps(type: :utc_datetime)
    end
  end
end
