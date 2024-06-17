defmodule HexatubeWeb.UserRegistrationController do
  use HexatubeWeb, :controller
  use PhoenixSwagger

  alias Hexatube.Accounts
  alias HexatubeWeb.UserRegistrationSchemas

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
    with {:ok, valid_data} <- UserRegistrationSchemas.new_user(params),
         {:ok, _user} <- Accounts.register_user(%{"name" => valid_data["username"], "password" => valid_data["password"]}) do
        conn
        |> render(:empty)
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
