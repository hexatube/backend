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
end