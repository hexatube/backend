defmodule Hexatube.Repo.Migrations.CreateNothings do
  use Ecto.Migration

  def change do
    create table(:nothings) do
      add :age, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
