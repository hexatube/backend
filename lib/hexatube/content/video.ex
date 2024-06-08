defmodule Hexatube.Content.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :category, :string
    field :name, :string
    field :path, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :path, :category])
    |> validate_required([:name, :path, :category])
  end
end
