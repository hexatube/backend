defmodule HexatubeWeb.NothingJSON do
  alias Hexatube.Tests.Nothing

  @doc """
  Renders a list of nothings.
  """
  def index(%{nothings: nothings}) do
    %{data: for(nothing <- nothings, do: data(nothing))}
  end

  @doc """
  Renders a single nothing.
  """
  def show(%{nothing: nothing}) do
    %{data: data(nothing)}
  end

  defp data(%Nothing{} = nothing) do
    %{
      id: nothing.id,
      age: nothing.age
    }
  end
end
