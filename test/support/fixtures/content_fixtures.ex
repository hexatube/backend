defmodule Hexatube.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hexatube.Content` context.
  """

  alias Hexatube.AccountsFixtures

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    v = attrs
      |> Enum.into(%{
        category: "some category",
        name: "some name",
        path: "some path"
      })
      
    u = AccountsFixtures.user_fixture()

    {:ok, video} = Hexatube.Content.create_video(u, v)
    video
  end
end
