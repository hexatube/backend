defmodule Hexatube.TestsTest do
  use Hexatube.DataCase

  alias Hexatube.Tests

  describe "nothings" do
    alias Hexatube.Tests.Nothing

    import Hexatube.TestsFixtures

    @invalid_attrs %{age: nil}

    test "list_nothings/0 returns all nothings" do
      nothing = nothing_fixture()
      assert Tests.list_nothings() == [nothing]
    end

    test "get_nothing!/1 returns the nothing with given id" do
      nothing = nothing_fixture()
      assert Tests.get_nothing!(nothing.id) == nothing
    end

    test "create_nothing/1 with valid data creates a nothing" do
      valid_attrs = %{age: 42}

      assert {:ok, %Nothing{} = nothing} = Tests.create_nothing(valid_attrs)
      assert nothing.age == 42
    end

    test "create_nothing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tests.create_nothing(@invalid_attrs)
    end

    test "update_nothing/2 with valid data updates the nothing" do
      nothing = nothing_fixture()
      update_attrs = %{age: 43}

      assert {:ok, %Nothing{} = nothing} = Tests.update_nothing(nothing, update_attrs)
      assert nothing.age == 43
    end

    test "update_nothing/2 with invalid data returns error changeset" do
      nothing = nothing_fixture()
      assert {:error, %Ecto.Changeset{}} = Tests.update_nothing(nothing, @invalid_attrs)
      assert nothing == Tests.get_nothing!(nothing.id)
    end

    test "delete_nothing/1 deletes the nothing" do
      nothing = nothing_fixture()
      assert {:ok, %Nothing{}} = Tests.delete_nothing(nothing)
      assert_raise Ecto.NoResultsError, fn -> Tests.get_nothing!(nothing.id) end
    end

    test "change_nothing/1 returns a nothing changeset" do
      nothing = nothing_fixture()
      assert %Ecto.Changeset{} = Tests.change_nothing(nothing)
    end
  end
end
