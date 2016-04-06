defmodule Concierge.Confirmable.ConfirmationsController do
  use Concierge.Web, :controller

  def show(conn, params = %{"email" => email, "confirmation_token" => confirmation_token}) do    
    case Confirmable.Resource.confirm!(email, confirmation_token) do
      {:ok, resource} -> Concierge.Session.sign_in_and_redirect(conn, resource)  
      {:error} ->
        conn
          |> put_flash(:error, "Confirmation token is invalid")    
          |> render
    end
  end

  def show(conn, params) do
    render(conn)
  end
end