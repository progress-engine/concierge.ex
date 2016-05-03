defmodule Recoverable.ResourceTest do
  use ExUnit.Case
  use Plug.Test

  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Recoverable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Recoverable.TestRepo)
    end
  end

  test "generates new token on resource" do
    assert {:ok, user = %Recoverable.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert :ok = Recoverable.Resource.send_reset_password_instructions(user)

    user = Recoverable.TestRepo.get(Recoverable.TestUser, user.id)
    assert user.reset_password_token != nil
  end

  test "sends email and generates sent time" do
    assert {:ok, user = %Recoverable.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    assert :ok = Recoverable.Resource.send_reset_password_instructions(user)

    user = Recoverable.TestRepo.get(Recoverable.TestUser, user.id)
    assert user.reset_password_token_sent_at != nil
  end

  test "changes password" do
    assert {:ok, user = %Recoverable.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})  

    assert {:ok, user = %Recoverable.TestUser{}} = Recoverable.Resource.reset_password(user, "new_password", "new_password")
    assert Concierge.Resource.valid_password?(user, "new_password")
  end
end