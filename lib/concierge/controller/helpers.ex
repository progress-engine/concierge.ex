defmodule Concierge.Controller.Helpers do
  
  defmacro __using__(_) do
    quote do
      @doc false
      defp sign_in_and_redirect(conn, resource) do
        case Concierge.Session.sign_in(conn, resource) do
          {:ok, conn} ->
            conn 
            |> put_flash(:info, "Successfully authenticated")
            |> redirect(to: "/")  
          {:error, message} ->
            conn  
            |> put_flash(:error, message)
            |> redirect(to: "/")  
        end
      end
    end
  end
end