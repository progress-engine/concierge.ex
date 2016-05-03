defmodule Concierge.Resource.AuthenticationTest do
  use ExUnit.Case
  use Plug.Test

  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Concierge.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Concierge.TestRepo)
    end
  end

  test "authenticates resource with correct password" do
    {:ok, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:ok, %Concierge.TestUser{}} = Concierge.Resource.Authentication.authenticate("concierge@test.com", "123456789")    
  end

  test "refuse authentication with incorrect password" do
    {:ok, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.Authentication.authenticate("concierge@test.com", "1111")    
  end

  test "refuse authentication with empty password" do
    {:ok, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.Authentication.authenticate("concierge@test.com", "")    
  end

  test "refuse authentication with missing password" do
    {:ok, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.Authentication.authenticate("concierge@test.com")    
  end

  test "cleans up parameters on invalid credentians" do
    {:ok, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})    

    assert {:error, changeset} = Concierge.Resource.Authentication.authenticate("concierge@test.com", "123 ")    
    assert Access.get(changeset.params, "email") == "concierge@test.com"
    assert Access.get(changeset.params, "password") == nil
  end
end