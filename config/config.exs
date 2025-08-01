# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :piruet,
  ecto_repos: [Piruet.Repo],
  generators: [timestamp_type: :utc_datetime],
  client_id: "1399420897596543076",
  client_secret: "Xvj7T8AHWpVBkM4IZC-2acj-1xEG425t",
  redirect_uri: "http://piruetik-music.com:4000/callback"

# Configures the endpoint
config :piruet, PiruetWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PiruetWeb.ErrorHTML, json: PiruetWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Piruet.PubSub,
  live_view: [signing_salt: "EDuzEi55"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :piruet, Piruet.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  piruet: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  piruet: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :nostrum, 
  youtubedl: "/usr/bin/yt-dlp",
  ffmpeg: "/usr/bin/ffmpeg",
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto,
  gateway_intents: [:guild_messages, :guilds, :guild_voice_states, :direct_messages],
  dispatch_modules: [Piruet.Consumer]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
