defmodule Hexatube.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hexatube.Content` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        category: "some category",
        name: "some name",
        path: "some path"
      })
      |> Hexatube.Content.create_video()

    video
  end
end
