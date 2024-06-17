defmodule HexatubeWeb.UserRegistrationControllerTest do
  use HexatubeWeb.ConnCase, async: true

  import Hexatube.AccountsFixtures

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

  describe "POST /login" do
    @tag :capture_log
    setup :register_user

    test "authenticate", %{conn: conn, user: user} do
      conn = post(conn, ~p"/login", %{
        "username" => user.name,
        "password" => valid_user_password(),
      })
      response = json_response(conn, 200)
      assert response == %{}
      assert get_session(conn, :user_token)
    end

    test "wrong password", %{conn: conn, user: user} do
      conn = post(conn, ~p"/login", %{
        "username" => user.name,
        "password" => "123",
      })
      response = json_response(conn, 200)
      assert response == %{"errors" => ["authentication failed"]}
      refute get_session(conn, :user_token)
    end
  end

  describe "POST /logout" do
    @tag :capture_log
    setup :register_and_log_in_user

    test "logout", %{conn: conn, user: user} do
      conn = post(conn, ~p"/logout", %{})
      response = json_response(conn, 200)
      assert response == %{}
      refute get_session(conn, :user_token)
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
