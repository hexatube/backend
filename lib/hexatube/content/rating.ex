defmodule Hexatube.Content.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :like, :boolean, default: false
    belongs_to :user, Hexatube.Accounts.User
    belongs_to :video, Hexatube.Content.Video

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:like])
    |> validate_required([:like])
  end
end
