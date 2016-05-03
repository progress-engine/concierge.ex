defmodule Recoverable.PasswordControllerTest do
  use Recoverable.ConnCase
  alias Ecto.Adapters.SQL

  import Mock

  setup do
    SQL.begin_test_transaction(Recoverable.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Recoverable.TestRepo)
    end
  end

  test "shows password recovery page", %{conn: conn} do
    conn = get(conn, "/users/passwords/new")

    assert conn.status == 200
  end

  test "redirects after password recovery request", %{conn: conn} do
    Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    user_data = [email: "concierge@test.com"]
    conn = post(conn, Concierge.route_helpers.password_path(conn, :create), [user: user_data])

    assert conn.status == 302
  end

  test "sends email after password recovery request", %{conn: conn} do
    Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    user_data = [email: "concierge@test.com"]

    with_mock Mailgun.Client, [send_email: fn _, _ -> {:ok, "response"} end] do
      conn = post(conn, Concierge.route_helpers.password_path(conn, :create), [user: user_data])

      assert called Mailgun.Client.send_email(:_, :_)
    end
  end

  test "shows edit password page" do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    changeset = Ecto.Changeset.change(resource, %{reset_password_token: "token"})
    Concierge.repo.update!(changeset) 

    conn = get(conn, "/users/passwords/edit?email=#{resource.email}&reset_password_token=token")

    assert conn.status == 200
  end

  test "should not show edit password page with invalid token" do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    changeset = Ecto.Changeset.change(resource, %{reset_password_token: "token"})
    Concierge.repo.update!(changeset) 

    conn = get(conn, "/users/passwords/edit?email=#{resource.email}&reset_password_token=token1")

    assert conn.status != 200
  end

  test "should update password and redirect" do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    changeset = Ecto.Changeset.change(resource, %{reset_password_token: "token"})
    Concierge.repo.update!(changeset) 


    conn = put(conn, Concierge.route_helpers.password_path(conn, :update), %{"user" => 
      %{"password" => "new_password", "password_confirmation" => "new_password", "reset_password_token" => "token"}})   
    assert conn.status == 302
  end

  test "should show error on invalid credentials" do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    changeset = Ecto.Changeset.change(resource, %{reset_password_token: "token"})
    Concierge.repo.update!(changeset) 

    conn = put(conn, Concierge.route_helpers.password_path(conn, :update), %{"user" => 
      %{"password" => "new_password", "password_confirmation" => "password", "reset_password_token" => "token"}})   
    assert conn.status == 422
  end
end
