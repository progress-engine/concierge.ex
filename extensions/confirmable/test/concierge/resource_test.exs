defmodule Concierge.ResourceTest do
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

  test "creates user" do
    assert {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})
    assert user.email == "concierge@test.com"  
  end 

  test "calls mailer" do
    with_mock Mailgun.Client, [send_email: fn _, _ -> {:ok, "response"} end] do
      {:ok, user} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
        "password" => "123456789", "password_confirmation" => "123456789"})  

      assert called Mailgun.Client.send_email(:_, :_)
    end
  end
end