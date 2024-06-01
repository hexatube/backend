defmodule HexatubeWeb.NothingController do
  use HexatubeWeb, :controller

  alias Hexatube.Tests
  alias Hexatube.Tests.Nothing

  action_fallback HexatubeWeb.FallbackController

  def index(conn, _params) do
    nothings = Tests.list_nothings()
    render(conn, :index, nothings: nothings)
  end

  def create(conn, %{"nothing" => nothing_params}) do
    with {:ok, %Nothing{} = nothing} <- Tests.create_nothing(nothing_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/nothings/#{nothing}")
      |> render(:show, nothing: nothing)
    end
  end

  def show(conn, %{"id" => id}) do
    nothing = Tests.get_nothing!(id)
    render(conn, :show, nothing: nothing)
  end

  def update(conn, %{"id" => id, "nothing" => nothing_params}) do
    nothing = Tests.get_nothing!(id)

    with {:ok, %Nothing{} = nothing} <- Tests.update_nothing(nothing, nothing_params) do
      render(conn, :show, nothing: nothing)
    end
  end

  def delete(conn, %{"id" => id}) do
    nothing = Tests.get_nothing!(id)

    with {:ok, %Nothing{}} <- Tests.delete_nothing(nothing) do
      send_resp(conn, :no_content, "")
    end
  end
end
