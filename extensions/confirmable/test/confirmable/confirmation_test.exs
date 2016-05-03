defmodule Confirmable.ConfirmationTest do
  use ExUnit.Case
  use Plug.Test

  alias Ecto.Adapters.SQL
  import Mock

  setup do
    SQL.begin_test_transaction(Confirmable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Confirmable.TestRepo)
    end
  end
  
  test "generates sent time" do
    {:ok, user} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    assert user.confirmation_sent_at != nil
  end

  test "generates confirmation token" do
    {:ok, user} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    assert user.confirmation_token != nil
  end
end