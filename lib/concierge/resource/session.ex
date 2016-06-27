defmodule Concierge.Resource.Session do
  use Phoenix.Controller

  @moduledoc """
  Holds functions to perform resource sign in and sign
  """

  defmodule Callbacks do
    @moduledoc """
    Defines callbacks for resource session actions
    """

    @doc """
    Runs before sign in. 
    To halt the whole process you can use `throw {:error, "Error message"}` construction.
    """
    @callback before_sign_in(Plug.Conn.t, Ecto.Schema.t) :: {:ok} | {:error, any}

    @doc """
    Runs after sign in. 
    """
    @callback after_sign_in(Plug.Conn.t, Ecto.Schema.t) :: any
  end

  @doc """
  Signs resource in
  """
  def sign_in(conn, resource) do  
    case Concierge.Utils.invoke_on_extensions(:before_sign_in, [conn, resource]) do
      {:ok} ->
        conn = Guardian.Plug.sign_in(conn, resource)       
        {:ok, conn}
      {:error, message} -> {:error, message}    
    end
  end

  @doc """
  Ends current session
  """
  def sign_out(conn) do
    Guardian.Plug.sign_out(conn)
  end
end