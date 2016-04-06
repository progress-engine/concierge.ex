Mix.Task.run "ecto.create", ["quiet", "-r", "Concierge.TestRepo"]
Mix.Task.run "ecto.migrate", ["-r", "Concierge.TestRepo"]

Concierge.Endpoint.start_link
Concierge.TestRepo.start_link
ExUnit.start()