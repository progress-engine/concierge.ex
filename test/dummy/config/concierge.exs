use Mix.Config

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Dummy",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "sdf",
  serializer: Dummy.GuardianSerializer

config :concierge, Concierge,
  otp_app: Dummy,
  # repo: Dummy.Repo,
  # resource: Dummy.User,
  # route_helpers: Dummy.Router.Helpers,
  resource_name: "user",
  # layout: {Dummy.LayoutView, "app.html"}
  # extensions: [Concierge.Confirmable, Concierge.Recoverable]
  extensions: [Concierge.Confirmable]