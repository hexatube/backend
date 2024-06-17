defmodule HexatubeWeb.UserRegistrationSchemas do
  @moduledoc """
  API requests validation schemas.
  """
  import Peri

  defschema :new_user, %{
    username: {:required, :string},
    password: {:required, :string}
  }

  defschema :login, %{
    username: {:required, :string},
    password: {:required, :string}
  }
end
