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
end
