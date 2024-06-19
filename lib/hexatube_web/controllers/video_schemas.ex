defmodule HexatubeWeb.VideoSchemas do
  @moduledoc """
  Video controller API schemas.
  """
  import Peri

  defschema :like, %{
    id: {:required, :integer},
  }
end