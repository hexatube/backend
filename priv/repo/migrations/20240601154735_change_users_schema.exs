defmodule Hexatube.Repo.Migrations.ChangeUsersSchema do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :hashed_password, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:name])
  end
end
