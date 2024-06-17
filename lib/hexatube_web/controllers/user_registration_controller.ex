defmodule HexatubeWeb.UserRegistrationController do
  use HexatubeWeb, :controller
  use PhoenixSwagger

  alias Hexatube.Accounts

  action_fallback HexatubeWeb.FallbackController

  def swagger_definitions do
    %{
      NewUser: swagger_schema do
        title "NewUser"
        description "User object for registration"
        properties do
          username :string, "username", required: true
          password :string, "password", required: true
        end
        example %{
          username: "Ivan",
          password: "qwerty1234"
        }
      end,
      User: swagger_schema do
        title "User"
        description "User object"
        properties do
          username :string, "username", required: true
        end
        example %{
          username: "Ivan",
        }
      end
    }
  end

  swagger_path :new_user do
    description "Register new user"
    produces "application/json"
    parameter :user, :body, Schema.ref(:NewUser), "user object"
    response 200, "Success"
  end

  def new_user(conn, params) do
    %{"username" => username, "password" => password} = params
    case Accounts.register_user(%{"name" => username, "password" => password}) do
      {:ok, _user} ->
        conn
        |> render(:empty)

      e -> e
    end
  end

  swagger_path :me do
    description "Get information about current user"
    produces "application/json"
    response 200, "Success", Schema.ref(:User)
  end

  def me(conn, params) do
    user = conn.assigns.current_user
    render(conn, :me, user: user)
  end
end
