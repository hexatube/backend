defmodule Hexatube.AccountsTest do
  use Hexatube.DataCase

  alias Hexatube.Accounts

  import Hexatube.AccountsFixtures
  alias Hexatube.Accounts.{User, UserToken}

  describe "get_user_by_name/1" do
    test "does not return the user if the name does not exist" do
      refute Accounts.get_user_by_name("unknown")
    end

    test "returns the user if the name exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_name(user.name)
    end
  end

  describe "get_user_by_name_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_name_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture()
      refute Accounts.get_user_by_name_and_password(user.name, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = user_fixture()

      assert %User{id: ^id} =
               Accounts.get_user_by_name_and_password(user.name, valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               password: ["can't be blank"],
               name: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates name and password when given" do
      {:error, changeset} = Accounts.register_user(%{name: "not valid", password: "d"})

      assert %{
               password: ["should be at least 5 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for name and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_user(%{name: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).name
      assert "should be at most 30 character(s)" in errors_on(changeset).password
    end

    test "validates name uniqueness" do
      %{name: name} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{name: name})
      assert "has already been taken" in errors_on(changeset).name

      {:error, changeset} = Accounts.register_user(%{name: name})
      assert "has already been taken" in errors_on(changeset).name
    end

    test "registers users with a hashed password" do
      name = unique_user_name()
      {:ok, user} = Accounts.register_user(valid_user_attributes(name: name))
      assert user.name == name
      assert is_binary(user.hashed_password)
      assert is_nil(user.password)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:password, :name]
    end

    test "allows fields to be set" do
      email = unique_user_name()
      password = valid_user_password()

      changeset =
        Accounts.change_user_registration(
          %User{},
          valid_user_attributes(name: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :name) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_user_name/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_name(%User{})
      assert changeset.required == [:name]
    end
  end

  describe "apply_user_name/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} = Accounts.apply_user_name(user, valid_user_password(), %{})
      assert %{name: ["did not change"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_user_name(user, valid_user_password(), %{name: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).name
    end

    test "validates email uniqueness", %{user: user} do
      %{name: email} = user_fixture()
      password = valid_user_password()

      {:error, changeset} = Accounts.apply_user_name(user, password, %{name: email})

      assert "has already been taken" in errors_on(changeset).name
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_name(user, "invalid", %{name: unique_user_name()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{user: user} do
      email = unique_user_name()
      {:ok, user} = Accounts.apply_user_name(user, valid_user_password(), %{name: email})
      assert user.name == email
      assert Accounts.get_user!(user.id).name != email
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_user_password(%User{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_user_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "inspect/2 for the User module" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
