defmodule Hexatube.Content.Video do
  @moduledoc """
  Video schema for DB.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :category, :string
    field :name, :string
    field :path, :string
    field :preview_path, :string
    field :type, :string
    belongs_to :user, Hexatube.Accounts.User
    has_many :ratings, Hexatube.Content.Rating

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :path, :preview_path, :category, :type])
    |> validate_required([:name, :path, :preview_path, :category, :type])
  end
end
