defmodule Concierge.SessionsControllerTest do
  use Concierge.ConnCase
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Concierge.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Concierge.TestRepo)
    end
  end

  test "shows sign_in page", %{conn: conn} do
    conn = get(conn, "/users/sign_in")

    assert conn.status == 200
  end

  test "sign in", %{conn: conn} do
    {:ok, _user = %Concierge.TestUser{}} = Concierge.Resource.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    conn = post(conn, Concierge.route_helpers.sessions_path(conn, :new, %{
      "user" => %{ 
        "email" => "concierge@test.com", 
        "password" => "123456789",
      }
    }))

    assert conn.status == 302
  end
end
