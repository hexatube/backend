defmodule HexatubeWeb.UserRegistrationSchemas do
  import Peri

  defschema :new_user, %{
    username: {:required, :string},
    password: {:required, :string}
  }
end