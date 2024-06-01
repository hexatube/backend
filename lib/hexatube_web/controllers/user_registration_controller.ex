defmodule HexatubeWeb.UserRegistrationController do
  use HexatubeWeb, :controller

  alias Hexatube.Accounts
  alias Hexatube.Accounts.User
  alias HexatubeWeb.UserAuth

  action_fallback HexatubeWeb.FallbackController

  # def new(conn, _params) do
  #   changeset = Accounts.change_user_registration(%User{})
  #   render(conn, :new, changeset: changeset)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   case Accounts.register_user(user_params) do
  #     {:ok, user} ->
  #       {:ok, _} =
  #         Accounts.deliver_user_confirmation_instructions(
  #           user,
  #           &url(~p"/users/confirm/#{&1}")
  #         )

  #       conn
  #       |> put_flash(:info, "User created successfully.")
  #       |> UserAuth.log_in_user(user)

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, :new, changeset: changeset)
  #   end
  # end

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
