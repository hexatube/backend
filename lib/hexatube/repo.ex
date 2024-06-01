defmodule Hexatube.Repo do
  use Ecto.Repo,
    otp_app: :hexatube,
    adapter: Ecto.Adapters.Postgres
end
