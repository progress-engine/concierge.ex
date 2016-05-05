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

  test "it refuses sign in if user unconfirmed" do
     {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    refute Confirmable.Resource.confirmed?(user)

    assert {:error, _} = Concierge.Resource.Session.sign_in(Phoenix.ConnTest.conn(), user)
  end

  test "it signs in confirmed user" do
    {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })
    {:ok, user} = Confirmable.Resource.confirm!(user)

    assert Confirmable.Resource.confirmed?(user)

    with_mock Guardian.Plug, [sign_in: fn conn, _ -> conn end] do
      assert {:ok, %Plug.Conn{}} = Concierge.Resource.Session.sign_in(Phoenix.ConnTest.conn(), user)

      assert called Guardian.Plug.sign_in(:_, user)
    end
  end
end