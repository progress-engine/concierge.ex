defmodule Concierge.SessionsController do
  use Concierge.Web, :controller
  import Concierge, only: [resource: 0]

  def new(conn, _params) do
    changeset = resource.changeset(resource.__struct__)
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Concierge.Resource.authenticate(user_params) do
      {:ok, user} -> sign_in_and_redirect(conn, user)       
      {:error, changeset} -> 
        conn           
        |> put_flash(:error, "Invalid credentials")
        |> put_status(:unprocessable_entity)
        |> render("new.html", changeset: changeset)
    end      
  end

  def destroy(conn, _params) do
    Concierge.Session.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end