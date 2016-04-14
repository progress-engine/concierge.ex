use Mix.Config

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "<%= base %>",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "sdf",
  serializer: <%= base %>.GuardianSerializer

config :concierge, Concierge,
  # Name of the application. If present, Concierge will 
  # use it to determine standard Phoenix's module names
  otp_app: <%= base %>,
  resource_name: <%= inspect singular %>
  # repo: <%= base %>.Repo,
  # resource: <%= module %>,
  # layout: {<%= base %>.LayoutView, "app.html"}