defmodule Concierge.Controller do
  defmodule AuthErrorHandler do
    use Concierge.Web, :controller

    def unauthenticated(conn, _params) do
      conn 
      |> put_flash(:error, "Unauthenticated")
      |> redirect(to: "/")
    end  
  end

  @doc false
  defmacro __using__(_) do    
    quote do       
      use Concierge.Helpers
      use Concierge.Controller.Helpers
      import Concierge.Controller
    end
  end

  @doc """
  Redirects unless user is signed in
  """
  defmacro ensure_authenticated!(opts \\ %{}) do
    only = Keyword.get(opts, :only, [])
    except = Keyword.get(opts, :except, [])
    handler = Keyword.get(opts, :handler, Concierge.auth_error_handler)

    cond do
      Enum.any?(only) ->
        quote do
          plug Guardian.Plug.EnsureAuthenticated, [
            handler: unquote(handler)] when var!(action) in unquote(only) 
        end
      Enum.any?(except) ->
        quote do
          plug Guardian.Plug.EnsureAuthenticated, [
            handler: unquote(handler)] when not var!(action) in unquote(except) 
        end
      true ->  
        quote do
          plug Guardian.Plug.EnsureAuthenticated, [handler: unquote(handler)]
        end
    end
  end
end