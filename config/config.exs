# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :phoenix_blog, PhoenixBlog.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "8LDWABUWyuxMeXmJdf52JLZ693Beb+ms0Fm7V/lURcpiMk/PJ7cBz9YqbrMuA+os",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: PhoenixBlog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "PhoenixBlog",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "SECRET",
  serializer: PhoenixBlog.GuardianSerializer

config :canary, repo: PhoenixBlog.Repo, unauthorized_handler: {PhoenixBlog.SessionController, :unauthorized}
