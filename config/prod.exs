import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Hexatube.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :hexatube, Hexatube.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "172.17.0.1",
  database: "hexatube_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: false,
  pool_size: 10

config :hexatube, HexatubeWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: false,
  debug_errors: true,
  secret_key_base: "umm+s+CJYlAFwyMQuDbBS4V9+SICRrxVLvCHcpyzuyYlj26bEDcC5Hc5zTWMK2pW",
  watchers: []

config :hexatube, dev_routes: true
