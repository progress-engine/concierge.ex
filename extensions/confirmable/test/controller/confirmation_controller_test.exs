defmodule Confirmable.ConfirmationControllerTest do
  use Confirmable.ConnCase
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Confirmable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Confirmable.TestRepo)
    end
  end

  test "confirms user when visiting confirmation page", %{conn: conn} do
    {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)

    conn = get(conn, Concierge.route_helpers.confirmation_path(conn, :show), 
      [email: user.email, confirmation_token: user.confirmation_token])

    assert conn.status == 302

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    assert Confirmable.Resource.confirmed?(user)
  end

  test "shows error when token is incorrect" do
    {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    conn = get(conn, Concierge.route_helpers.confirmation_path(conn, :show), 
      [email: user.email, confirmation_token: "invalid_token"])

    assert conn.status == 422

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    refute Confirmable.Resource.confirmed?(user)
  end

  test "shows error when token is empty" do
    {:ok, user = %Confirmable.TestUser{}} = Concierge.Resource.Registration.create(%{
      "email" => "concierge@test.com", 
      "password" => "123456789", 
      "password_confirmation" => "123456789",
    })

    conn = get(conn, Concierge.route_helpers.confirmation_path(conn, :show), 
      [email: user.email])

    assert conn.status == 422

    user = Confirmable.TestRepo.get(Confirmable.TestUser, user.id)
    refute Confirmable.Resource.confirmed?(user)
  end
end
