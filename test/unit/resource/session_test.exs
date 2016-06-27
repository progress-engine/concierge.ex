defmodule Concierge.Resource.SessionTest do
  use ExUnit.Case
  use Concierge.ConnCase
  use Plug.Test

  import Mock
  alias Ecto.Adapters.SQL

  defmodule DummyExtension do
    @behaviour Concierge.Resource.Session.Callbacks

    def before_sign_in(_, resource) do
      {:ok}
    end

    def after_sign_in(_, _), do: {:ok}
  end

  defmodule DummyFailExtension do
    @behaviour Concierge.Resource.Session.Callbacks

    def before_sign_in(_, resource) do
      {:error, "Error message"}
    end

    def after_sign_in(_, _), do: {:ok}
  end

  setup do
    SQL.begin_test_transaction(Concierge.TestRepo)

    on_exit fn ->
      SQL.rollback_test_transaction(Concierge.TestRepo)
    end
  end

  test "signs in successfully with callback", %{conn: conn} do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    with_mock Concierge, [extensions: fn -> [DummyExtension] end] do
      with_mock Guardian.Plug, [sign_in: fn(_, _) -> %Plug.Conn{} end] do
        assert {:ok, %Plug.Conn{}} = Concierge.Resource.Session.sign_in(conn, resource)
        assert called Guardian.Plug.sign_in(:_, :_)
      end
    end
  end

  test "does not sign in if callback was failed", %{conn: conn} do
    {:ok, resource} = Concierge.Resource.Registration.create(%{"email" => "concierge@test.com", 
      "password" => "123456789", "password_confirmation" => "123456789"})

    with_mock Concierge, [extensions: fn -> [DummyFailExtension] end] do
      with_mock Guardian.Plug, [sign_in: fn(_, _) -> nil end] do
        assert {:error, "Error message"} = Concierge.Resource.Session.sign_in(conn, resource)
        refute called Guardian.Plug.sign_in(:_, :_)
      end
    end
  end
end