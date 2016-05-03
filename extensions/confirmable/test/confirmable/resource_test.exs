defmodule Confirmable.ResourceTest do
  use ExUnit.Case
  use Plug.Test

  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Confirmable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Confirmable.TestRepo)
    end
  end

  test "creates user" do
    assert {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})
    assert user.email == "concierge@test.com"  
  end 

  test "confirms resource" do
    {:ok, user} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)

    assert {:ok, user = %Confirmable.TestUser{}} = Confirmable.Resource.confirm!(user.email, user.confirmation_token)
  end

  test "resource is confirmed after confirmation" do
    {:ok, user} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})
    
    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    Confirmable.Resource.confirm!(user.email, user.confirmation_token)

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    assert Confirmable.Resource.confirmed?(user)
  end
end