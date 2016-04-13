defmodule Concierge.Resource do  
  @moduledoc """
  A set of functions to work with concierge resource.
  """

  @doc """
  Creates resource from given parameters. 
  By default resource requires `email`, `password` and `password_confirmation` parameters.

  Returns `{:ok, resource}` if creation was successful; otherwise returns `{:error, changeset}`.
  `resource` is a `Ecto.Schema` module represeting your resource.
  `changeset` is a `Ecto.Changeset` module.

  ## Examples

    def create(conn, params) do
      result = 
        params 
          |> Map.take(["email", "password", "password_confirmation"])
          |> Concierge.Resource.create

      case result do
        {:ok, resource} ->
          conn 
            |> put_flash("Successfully registered")
            |> redirect(to: "/")
        {:error, changeset} ->
          conn
            |> render("new.html", changeset: changeset)    
      end    
    end  
  """
  def create(params) do
    changeset = resource.changeset(resource.__struct__, params)
    
    {:ok, result} = 
      Concierge.repo.transaction(fn ->    
        Enum.map(Concierge.extensions, fn(ex) -> ex.before_create(changeset) end)  

        res = 
          changeset 
            |> with_encrypted_password
            |> Concierge.repo.insert

        case res do
          {:ok, resource} -> Enum.map(Concierge.extensions, fn(ex) -> ex.after_create(resource) end)
          {:error, _} -> nil
        end    
        res
      end)

    result
  end

  @doc """
  Fetch resource by its unique attribute(`email`) and check if given password is correct.
  Returns `{:ok, resource}` if authentication was successful; otherwise returns `{:error, changeset}`. 

  Changeset will contain prefilled user information fields. Password field will be blank

  ## Examples

    {:ok, resource} = Concierge.Resource.authenticate("test@test.com", "valid_password"})
    {:error, changeset} = Concierge.Resource.authenticate("test@test.com", "invalid_password"})
  """
  def authenticate(email, password) when byte_size(email) > 0 and byte_size(password) > 0 do
    user = get_resource_by_authentication_key(email) 

    if valid_password?(user, password) do
      {:ok, user}
    else
      {:error, changeset_from(%{"email" => email})}
    end      
  end
  def authenticate(email, password) do
    {:error, changeset_from(%{"email" => email})}
  end
  def authenticate(%{"email" => email, "password" => password}) do
    authenticate(email, password)
  end
  def authenticate(_) do
    {:error, changeset_from(%{})}
  end

  @doc false
  defp get_resource_by_authentication_key(authentication_key) do
    Concierge.repo.get_by(resource, email: authentication_key)
  end

  @doc false
  defp with_encrypted_password(changeset) do
    encrypted_password = Comeonin.Bcrypt.hashpwsalt(changeset.params["password"])

    changeset |>
      Ecto.Changeset.put_change(:encrypted_password, encrypted_password)
  end

  @doc """
  Verifies whether a password (ie from sign in) is matches the resource's password.
  """
  defp valid_password?(nil, _), do: false
  defp valid_password?(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
  end

  @doc """
  Cleans up passwords from parameters and generate safe changeset without password filled
  """
  defp changeset_from(params) do
    cleaned_up_parameters = Map.take(params, ["email"])
    resource.changeset(resource.__struct__, cleaned_up_parameters) 
  end

  # TODO use import instead
  defp resource, do: Concierge.resource
end
