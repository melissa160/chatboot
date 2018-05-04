# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatboot, ecto_repos: [Chatboot.Repo]

# Configures the endpoint
config :chatboot, ChatbootWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vO6wCFx0tF9z14PCWC5wy0KrFW1pmRWWJxM34N6S/F1xgGivnzd9kS3U7V1x/btb",
  render_errors: [view: ChatbootWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chatboot.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :facebook_messenger,
  verify_token:
    "EAACwIBQG2oUBAGGMHq3hi4MhPt2ZCcIYCLRgJrMjxpYhACwonMopkCiInpCdIipbgHDPcYZAAmb6RfWMz4MVZBsgEbsZBVsaYNvuygZAHdB0qOL3y6GOcRVXtX1ZCLhUytY4aWsO3fIapTwTwcBqAscJfp2vqdqNjIqaQcS4SMbQZDZD",
  challenge_verification_token: "good-response"
