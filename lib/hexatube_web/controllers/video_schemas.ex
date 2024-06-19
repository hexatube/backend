defmodule HexatubeWeb.VideoSchemas do
  import Peri

  defschema :like, %{
    id: {:required, :integer},
  }
end