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
    @callback before_sign_in(Ecto.Schema.t) :: any

    @doc """
    Runs after sign in. 
    """
    @callback after_sign_in(Ecto.Schema.t) :: any
  end

  @doc """
  Signs resource in
  """
  def sign_in(conn, resource) do  
    Concierge.Utils.invoke_on_extensions(:before_sign_in, [resource])  

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