defmodule Recoverable.EctoCase do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Recoverable.TestRepo)
  end
end