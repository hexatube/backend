defmodule Hexatube.TestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hexatube.Tests` context.
  """

  @doc """
  Generate a nothing.
  """
  def nothing_fixture(attrs \\ %{}) do
    {:ok, nothing} =
      attrs
      |> Enum.into(%{
        age: 42
      })
      |> Hexatube.Tests.create_nothing()

    nothing
  end
end
