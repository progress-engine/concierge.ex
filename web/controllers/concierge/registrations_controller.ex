defmodule Concierge.RegistrationsController do
  use Concierge.Web, :controller
  import Concierge, only: [resource: 0]

  def new(conn, _params) do  
    changeset = resource.changeset(resource.__struct__)
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Concierge.Resource.create(user_params) do
      {:ok, user} -> sign_in_and_redirect(conn, user)        
      {:error, changeset} ->
        conn           
        |> render("new.html", changeset: changeset)    
    end
  end
end