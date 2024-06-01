defmodule HexatubeWeb.NothingControllerTest do
  use HexatubeWeb.ConnCase

  import Hexatube.TestsFixtures

  alias Hexatube.Tests.Nothing

  @create_attrs %{
    age: 42
  }
  @update_attrs %{
    age: 43
  }
  @invalid_attrs %{age: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all nothings", %{conn: conn} do
      conn = get(conn, ~p"/api/nothings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create nothing" do
    test "renders nothing when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/nothings", nothing: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/nothings/#{id}")

      assert %{
               "id" => ^id,
               "age" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/nothings", nothing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update nothing" do
    setup [:create_nothing]

    test "renders nothing when data is valid", %{conn: conn, nothing: %Nothing{id: id} = nothing} do
      conn = put(conn, ~p"/api/nothings/#{nothing}", nothing: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/nothings/#{id}")

      assert %{
               "id" => ^id,
               "age" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, nothing: nothing} do
      conn = put(conn, ~p"/api/nothings/#{nothing}", nothing: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete nothing" do
    setup [:create_nothing]

    test "deletes chosen nothing", %{conn: conn, nothing: nothing} do
      conn = delete(conn, ~p"/api/nothings/#{nothing}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/nothings/#{nothing}")
      end
    end
  end

  defp create_nothing(_) do
    nothing = nothing_fixture()
    %{nothing: nothing}
  end
end
