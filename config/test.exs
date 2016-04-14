use Mix.Config

config :guardian, Guardian,
  issuer: "Concierge",
  ttl: { 30, :days },
  secret_key: "test",
  serializer: Concierge.GuardianTestSerializer

config :concierge, Concierge,
  otp_app: Concierge,
  resource: Concierge.TestUser,
  repo: Concierge.TestRepo,
  resource_name: "user",
  route_helpers: Concierge.TestRouter.Helpers, 
  extensions: []

config :concierge, Concierge.TestRepo,
  hostname: "localhost",
  database: "concierge_test",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn  

config :concierge, Concierge.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Gjmff5liJuYidjcHHmUgCVCUoTfp6jNxDA67CdX5eyrEKobs4AqpJ4QpyG1G/UTo",
  debug_errors: true,
  cache_static_lookup: false,
  check_origin: false 