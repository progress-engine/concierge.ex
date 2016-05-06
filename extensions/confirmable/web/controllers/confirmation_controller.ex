defmodule Concierge.Confirmable.ConfirmationController do
  use Concierge.Web, :controller

  def show(conn, %{"email" => email, "confirmation_token" => confirmation_token}) do    
    case Confirmable.Resource.confirm!(email, confirmation_token) do
      {:ok, resource} -> sign_in_and_redirect(conn, resource)  
      {:error, message} -> error!(conn, message)
      {:error} -> error!(conn, "Confirmation token is invalid")
    end
  end

  def show(conn, _params) do
    error!(conn, "Invalid parameters")
  end

  defp error!(conn, message) do
    conn
    |> put_flash(:error, message)
    |> put_status(:unprocessable_entity)
    |> redirect(to: "/")  
  end
end