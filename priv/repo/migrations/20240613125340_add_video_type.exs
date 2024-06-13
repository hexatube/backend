defmodule Hexatube.Repo.Migrations.AddVideoType do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :type, :string, null: false, default: "video/mp4"
    end
  end
end
