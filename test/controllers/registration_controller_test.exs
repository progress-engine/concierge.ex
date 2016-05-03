defmodule Concierge.RegistrationControllerTest do
  use Concierge.ConnCase
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Concierge.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Concierge.TestRepo)
    end
  end

  test "shows sign_in page", %{conn: conn} do
    conn = get(conn, "/users/sign_up")

    assert conn.status == 200
  end

  test "sign up", %{conn: conn} do
    user_data = %{ "email" => "concierge@test.com",  "password" => "123456789", 
      "password_confirmation" => "123456789",
    }

    conn = post(conn, Concierge.route_helpers.registration_path(conn, :create, %{"user" => user_data}))

    assert conn.status == 302
  end
end
