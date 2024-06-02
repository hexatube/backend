defmodule HexatubeWeb.UserRegistrationController do
  use HexatubeWeb, :controller
  use PhoenixSwagger

  alias Hexatube.Accounts
  alias Hexatube.Accounts.User
  alias HexatubeWeb.UserAuth

  action_fallback HexatubeWeb.FallbackController

  swagger_path :new_user do
    description "Register new user"
    produces "application/json"
    parameter :user, :body, Schema.ref(:NewUser), "user object"
    response 200, "Success"
  end

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
    }
  end

  def new_user(conn, %{"username" => username, "password" => password}) do
    case Accounts.register_user(%{"name" => username, "password" => password}) do
      {:ok, user} ->
        conn
        |> render(:empty)

      e -> e
    end
  end
end
