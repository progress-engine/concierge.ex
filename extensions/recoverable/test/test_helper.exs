Mix.Task.run "ecto.create", ["quiet", "-r", "Recoverable.TestRepo"]
Mix.Task.run "ecto.migrate", ["-r", "Recoverable.TestRepo"]

Recoverable.Endpoint.start_link
Recoverable.TestRepo.start_link
ExUnit.start()
