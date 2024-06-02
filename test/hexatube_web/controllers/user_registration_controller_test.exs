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
  end
end
