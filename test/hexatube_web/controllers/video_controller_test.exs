defmodule HexatubeWeb.VideoControllerTest do
  use HexatubeWeb.ConnCase, async: true

  import Hexatube.ContentFixtures

  describe "POST /video/upload" do
    @tag :capture_log
    setup :register_and_log_in_user

    test "upload new video with user", %{conn: conn} do
      conn = post(conn, ~p"/video/upload", %{
        "video" => video_content_plug(),
        "preview" => preview_content_plug(),
        "name" => "testvideo",
        "category" => "all"
      })
      response = json_response(conn, 200)
      assert response["name"] == "testvideo"
      assert response["category"] == "all"
      assert response["type"] == "video/mp4"
      assert response["rating"]["likes"] == 0
      assert response["rating"]["dislikes"] == 0
    end
  end

  describe "non-auth POST /video/upload" do
    test "cannot upload video without user", %{conn: conn} do
      conn = post(conn, ~p"/video/upload", %{
        "video" => video_content_plug(),
        "preview" => preview_content_plug(),
        "name" => "testvideo",
        "category" => "all"
      })
      assert json_response(conn, 401)
    end
  end

  describe "POST /video/like or dislike" do
    @tag :capture_log
    setup [:register_and_log_in_user, :upload_new_video]

    test "like video", %{conn: conn, video: video} do
      conn = post(conn, ~p"/video/like", %{
        "id" => video.id,
      })
      assert json_response(conn, 200) == %{}

      conn = get(conn, ~p"/video", %{
        "id" => video.id,
      })
      response = json_response(conn, 200)
      assert response["rating"]["likes"] == 1
      assert response["rating"]["dislikes"] == 0
    end

    test "dislike video", %{conn: conn, video: video} do
      conn = post(conn, ~p"/video/dislike", %{
        "id" => video.id,
      })
      assert json_response(conn, 200) == %{}

      conn = get(conn, ~p"/video", %{
        "id" => video.id,
      })
      response = json_response(conn, 200)
      assert response["rating"]["likes"] == 0
      assert response["rating"]["dislikes"] == 1
    end

    test "like non-existent video", %{conn: conn} do
      conn = post(conn, ~p"/video/like", %{
        "id" => 99999,
      })
      assert %{"errors" => _} = json_response(conn, 422)
    end
  end

  defp upload_new_video(_) do
    video = video_fixture()
    %{video: video}
  end
end