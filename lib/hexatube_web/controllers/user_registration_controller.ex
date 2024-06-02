defmodule HexatubeWeb.UserRegistrationController do
  use HexatubeWeb, :controller

  alias Hexatube.Accounts
  alias Hexatube.Accounts.User
  alias HexatubeWeb.UserAuth

  action_fallback HexatubeWeb.FallbackController

  def new_user(conn, %{"username" => username, "password" => password}) do
    case Accounts.register_user(%{"name" => username, "password" => password}) do
      {:ok, user} ->
        conn
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new_user, changeset: changeset)
    end
  end
end
