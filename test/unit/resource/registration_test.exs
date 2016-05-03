defmodule Concierge.Resource.RegistrationTest do
  use ExUnit.Case
  use Plug.Test

  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Concierge.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Concierge.TestRepo)
    end
  end

  test "creates resource" do
    assert {:ok, user = %Concierge.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})
    assert user.email == "concierge@test.com"  
  end 

  test "create should fill encrypted password field" do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})
    
    assert resource.encrypted_password != nil && resource.encrypted_password != ""
  end

  test "should fail with empty password" do
    assert {:error, _} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "", "password_confirmation" => ""})        
  end
end