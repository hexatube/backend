defmodule Hexatube.Tests do
  @moduledoc """
  The Tests context.
  """

  import Ecto.Query, warn: false
  alias Hexatube.Repo

  alias Hexatube.Tests.Nothing

  @doc """
  Returns the list of nothings.

  ## Examples

      iex> list_nothings()
      [%Nothing{}, ...]

  """
  def list_nothings do
    Repo.all(Nothing)
  end

  @doc """
  Gets a single nothing.

  Raises `Ecto.NoResultsError` if the Nothing does not exist.

  ## Examples

      iex> get_nothing!(123)
      %Nothing{}

      iex> get_nothing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nothing!(id), do: Repo.get!(Nothing, id)

  @doc """
  Creates a nothing.

  ## Examples

      iex> create_nothing(%{field: value})
      {:ok, %Nothing{}}

      iex> create_nothing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nothing(attrs \\ %{}) do
    %Nothing{}
    |> Nothing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a nothing.

  ## Examples

      iex> update_nothing(nothing, %{field: new_value})
      {:ok, %Nothing{}}

      iex> update_nothing(nothing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nothing(%Nothing{} = nothing, attrs) do
    nothing
    |> Nothing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a nothing.

  ## Examples

      iex> delete_nothing(nothing)
      {:ok, %Nothing{}}

      iex> delete_nothing(nothing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nothing(%Nothing{} = nothing) do
    Repo.delete(nothing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nothing changes.

  ## Examples

      iex> change_nothing(nothing)
      %Ecto.Changeset{data: %Nothing{}}

  """
  def change_nothing(%Nothing{} = nothing, attrs \\ %{}) do
    Nothing.changeset(nothing, attrs)
  end
end
