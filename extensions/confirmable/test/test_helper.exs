Mix.Task.run "ecto.create", ["quiet", "-r", "Confirmable.TestRepo"]
Mix.Task.run "ecto.migrate", ["-r", "Confirmable.TestRepo"]

Confirmable.Endpoint.start_link
Confirmable.TestRepo.start_link
ExUnit.start()