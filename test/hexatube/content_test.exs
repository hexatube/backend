defmodule Hexatube.ContentTest do
  use Hexatube.DataCase

  alias Hexatube.Content

  describe "videos" do
    alias Hexatube.Content.Video
    alias Hexatube.AccountsFixtures

    import Hexatube.ContentFixtures

    @invalid_attrs %{category: nil, name: nil, path: nil, preview_path: nil, type: nil}

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Content.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Content.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      user = AccountsFixtures.user_fixture()
      valid_attrs = %{category: "some category", name: "some name", path: "some path", preview_path: "some preview", type: "video/mp4"}

      assert {:ok, %Video{} = video} = Content.create_video(user, valid_attrs)
      assert video.category == "some category"
      assert video.name == "some name"
      assert video.path == "some path"
      assert video.preview_path == "some preview"
      assert video.type == "video/mp4"
    end

    test "create_video/1 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.create_video(user, @invalid_attrs)
    end

    test "create_video_without_user/1 creates video" do
      valid_attrs = %{category: "some category", name: "some name", path: "some path", preview_path: "some preview", type: "video/mp4"}

      assert {:ok, %Video{} = video} = Content.create_video_without_user(valid_attrs)
      assert video.category == "some category"
      assert video.name == "some name"
      assert video.path == "some path"
      assert video.preview_path == "some preview"
      assert video.type == "video/mp4"
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      update_attrs = %{category: "some updated category", name: "some updated name", path: "some updated path", preview_path: "some updated preview", type: "video/webm"}

      assert {:ok, %Video{} = video} = Content.update_video(video, update_attrs)
      assert video.category == "some updated category"
      assert video.name == "some updated name"
      assert video.path == "some updated path"
      assert video.preview_path == "some updated preview"
      assert video.type == "video/webm"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_video(video, @invalid_attrs)
      assert video == Content.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Content.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Content.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Content.change_video(video)
    end
  end
end
