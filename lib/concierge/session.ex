defmodule Concierge.Session do
  use Phoenix.Controller

  @moduledoc """
  """

  @doc """
  Signs resource in
  """
  def sign_in(conn, resource) do    
    Enum.map(Concierge.extensions, fn(ex) -> ex.run_before_sign_in_callbacks!(resource) end) 

    conn = Guardian.Plug.sign_in(conn, resource)
    {:ok, conn}
  catch # TODO Invent cleaner way to return errors in before callbacks
    {:error, message} -> {:error, message}
  end

  @doc """
  Ends current session
  """
  def sign_out(conn) do
    Guardian.Plug.sign_out(conn)
  end
end