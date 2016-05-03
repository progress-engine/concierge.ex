defmodule Concierge.Recoverable.PasswordController do
  use Concierge.Web, :controller
  
  def new(conn, _params) do 
    changeset = Concierge.Utils.changeset(%{})
    render(conn, "new.html", %{changeset: changeset})
  end

  def create(conn, params = %{"user" => %{"email" => email}}) do
    resource = Concierge.Resource.get_by_authentication_key(email)

    case Recoverable.Resource.send_reset_password_instructions(resource) do
      :ok ->
        conn 
        |> put_flash(:info, "Email was sent")
        |> redirect(to: Concierge.route_helpers.session_path(conn, :new))
      :error -> 
        conn 
        |> put_flash(:error, "User was not found")  
        |> render("new.html", %{changeset: Concierge.Utils.changeset(%{})})
    end
  end

  def edit(conn, %{"email" => email, "reset_password_token" => token}) do 
    resource = Concierge.Resource.get_by(email: email, reset_password_token: token)

    case resource do
      nil ->
        conn 
        |> put_flash(:error, "Invalid token") 
        |> redirect(to: "/")
      _ ->  
        changeset = Concierge.Utils.changeset
        render(conn, "edit.html", %{changeset: changeset, reset_password_token: token})
    end
  end

  def update(conn, params = %{"user" => %{"password" => password, 
    "password_confirmation" => password_confirmation, "reset_password_token" => token}}) do
    resource = Concierge.Resource.get_by(reset_password_token: token)

    case Recoverable.Resource.reset_password(resource, password, password_confirmation) do
      {:ok, resource} ->
        conn 
        |> put_flash(:info, "Your password was changed. You can login now")
        |> redirect(to: Concierge.route_helpers.session_path(conn, :new))
      {:error, changeset} -> 
        conn 
        |> put_status(:unprocessable_entity) 
        |> render("edit.html", %{changeset: changeset, reset_password_token: token})
    end
  end
end