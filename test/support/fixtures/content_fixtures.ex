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
        path: "some path",
        preview_path: "some preview",
        type: "video/mp4"
      })
      
    u = AccountsFixtures.user_fixture()

    {:ok, video} = Hexatube.Content.create_video(u, v)
    video
  end

  def video_content_plug() do
    %Plug.Upload{
      path: Path.join(File.cwd!(), "test/support/fixtures/bigbuckbunny.mp4"),
      content_type: "video/mp4",
      filename: "bigbuckbunny.mp4"
    }
  end

  def preview_content_plug() do
    %Plug.Upload{
      path: Path.join(File.cwd!(), "test/support/fixtures/test.png"),
      content_type: "image/png",
      filename: "test.png"
    }
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()
    video = video_fixture()

    {:ok, rating} = Hexatube.Content.create_rating(user, video, Enum.into(attrs, %{like: true}))
    rating
  end
end
