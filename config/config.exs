# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :hexatube,
  ecto_repos: [Hexatube.Repo],
  generators: [timestamp_type: :utc_datetime],
  base_api: ""

# Configures the endpoint
config :hexatube, HexatubeWeb.Endpoint,
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: HexatubeWeb.ErrorHTML, json: HexatubeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Hexatube.PubSub,
  live_view: [signing_salt: "uyVHYVxg"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :hexatube, Hexatube.Mailer, adapter: Swoosh.Adapters.Local

config :hexatube, :phoenix_swagger,
    swagger_files: %{
      "priv/static/swagger.json" => [
        router: HexatubeWeb.Router,
        endpoint: HexatubeWeb.Endpoint,
      ]
    }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
