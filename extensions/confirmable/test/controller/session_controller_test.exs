defmodule Confirmable.SessionControllerTest do
  use Confirmable.ConnCase
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Confirmable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Confirmable.TestRepo)
    end
  end

  test "signs in", %{conn: conn} do
    {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })
    {:ok, user} = Confirmable.Resource.confirm!(user)

    assert Confirmable.Resource.confirmed?(user)

    conn = post(conn, Concierge.route_helpers.session_path(conn, :create, %{
      "user" => %{ 
        "email" => "concierge@test.com", 
        "password" => "123456789",
      }
    }))

    assert conn.status == 302
  end

  test "it refuses sign in if user unconfirmed" do
     {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    refute Confirmable.Resource.confirmed?(user)

    conn = post(conn, Concierge.route_helpers.session_path(conn, :create, %{
      "user" => %{ 
        "email" => "concierge@test.com", 
        "password" => "123456789",
      }
    }))

    assert conn.status == 401
  end
end
