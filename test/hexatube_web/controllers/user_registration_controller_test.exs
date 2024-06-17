defmodule HexatubeWeb.UserRegistrationControllerTest do
  use HexatubeWeb.ConnCase, async: true

  import Hexatube.AccountsFixtures
  alias HexatubeWeb.UserAuth

  describe "POST /login/register" do
    @tag :capture_log

    test "creates new user", %{conn: conn} do
      name = unique_user_name()
      password = valid_user_password()

      conn = post(conn, ~p"/login/register", %{
        "username" => name,
        "password" => password
      })

      response = json_response(conn, 200)
      assert response == %{}
    end

    test "create user with same name", %{conn: conn} do
      name = unique_user_name()
      password = valid_user_password()

      conn = post(conn, ~p"/login/register", %{
        "username" => name,
        "password" => password
      })
      response = json_response(conn, 200)
      assert response == %{}

      conn = post(conn, ~p"/login/register", %{
        "username" => name,
        "password" => password
      })
      response = json_response(conn, 422)
      assert response["errors"] != %{}
    end

    test "fail params validation", %{conn: conn} do
      conn = post(conn, ~p"/login/register", %{
        "username" => 123,
        "password" => 123 
      })
      response = json_response(conn, 200)
      assert %{"errors" => _} = response
    end
  end

  describe "GET /login/me" do
    @tag :capture_log
    setup :register_and_log_in_user

    test "get information about current user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/login/me")
      response = json_response(conn, 200)
      assert response["username"] == user.name
    end
  end
end
