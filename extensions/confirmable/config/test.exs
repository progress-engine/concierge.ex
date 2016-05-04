use Mix.Config

config :guardian, Guardian,
  issuer: "Concierge",
  ttl: { 30, :days },
  secret_key: "test",
  serializer: Confirmable.GuardianTestSerializer

config :concierge, Concierge,
  otp_app: Confirmable,
  resource: Confirmable.TestUser,
  repo: Confirmable.TestRepo,
  resource_name: "user",
  route_helpers: Confirmable.TestRouter.Helpers, 
  extensions: [Concierge.Confirmable]

config :confirmable, Confirmable.TestRepo,
  hostname: "localhost",
  database: "concierge_test",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn  

config :confirmable, Confirmable.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Gjmff5liJuYidjcHHmUgCVCUoTfp6jNxDA67CdX5eyrEKobs4AqpJ4QpyG1G/UTo",
  debug_errors: true,
  cache_static_lookup: false,
  check_origin: false   