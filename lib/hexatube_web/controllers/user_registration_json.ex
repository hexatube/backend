defmodule HexatubeWeb.UserRegistrationJSON do
  alias Hexatube.Accounts.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    data(user)
  end

  def empty(_) do
    %{}
  end

  defp data(%User{} = user) do
    %{username: user.name}
  end

  def me(%{user: user}) do
    data(user)
  end

  def auth_error(_) do
    %{
      errors: ["authentication failed"]
    }
  end
end
