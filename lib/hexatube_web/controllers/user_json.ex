defmodule HexatubeWeb.UserJSON do
	alias Hexatube.Accounts.User

	def index(%{users: users}) do
		%{data: for(user <- users, do: data(user))}
	end

	def show(%{user: user}) do
		%{data: data(user)}
	end

	defp data(%User{} = user) do
		%{
			name: user.name
		}
	end

end