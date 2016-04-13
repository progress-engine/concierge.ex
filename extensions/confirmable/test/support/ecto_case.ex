defmodule Confirmable.EctoCase do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Confirmable.TestRepo)
  end
end