defmodule Concierge.ResourceTest do
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
    assert {:ok, user = %Concierge.TestUser{}} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})
    assert user.email == "concierge@test.com"  
  end 

  test "create should fill encrypted password field" do
    {:ok, resource} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})
    
    assert resource.encrypted_password != nil && resource.encrypted_password != ""
  end

  test "authenticates resource with correct password" do
    {:ok, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:ok, %Concierge.TestUser{}} = Concierge.Resource.authenticate("concierge@test.com", "123456789")    
  end

  test "refuse authentication with incorrect password" do
    {:ok, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.authenticate("concierge@test.com", "1111")    
  end

  test "refuse authentication with empty password" do
    {:ok, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.authenticate("concierge@test.com", "")    
  end

  test "refuse authentication with missing password" do
    {:ok, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})

    assert {:error, _} = Concierge.Resource.authenticate("concierge@test.com")    
  end

  test "cleans up parameters on invalid credentians" do
    {:ok, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "123456789", "password_confirmation" => "123456789"})    

    assert {:error, changeset} = Concierge.Resource.authenticate("concierge@test.com", "123 ")    
    assert Access.get(changeset.params, "email") == "concierge@test.com"
    assert Access.get(changeset.params, "password") == nil
  end

  test "should fail with empty password" do
    assert {:error, _} = Concierge.Resource.create(%{"email" => "concierge@test.com", "password" => "", "password_confirmation" => ""})        
  end
end