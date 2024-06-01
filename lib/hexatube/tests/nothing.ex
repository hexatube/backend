defmodule Hexatube.Tests.Nothing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nothings" do
    field :age, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(nothing, attrs) do
    nothing
    |> cast(attrs, [:age])
    |> validate_required([:age])
  end
end
