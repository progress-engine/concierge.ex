defmodule Concierge.Resource.Authentication do
  @moduledoc """
  Holds authentification-related functions
  """

  @doc """
  Fetch resource by its unique attribute(`email`) and check if given password is correct.
  Returns `{:ok, resource}` if authentication was successful; otherwise returns `{:error, changeset}`. 

  Changeset will contain prefilled user information fields. Password field will be blank

  ## Examples

    {:ok, resource} = Concierge.Resource.authenticate("test@test.com", "valid_password"})
    {:error, changeset} = Concierge.Resource.authenticate("test@test.com", "invalid_password"})
  """
  def authenticate(email, password) when byte_size(email) > 0 and byte_size(password) > 0 do
    user = Concierge.Resource.get_by_authentication_key(email) 

    if Concierge.Resource.valid_password?(user, password) do
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

  @doc """
  Cleans up passwords from parameters and generate safe changeset without password filled
  """
  def changeset_from(params) do
    cleaned_up_parameters = Map.take(params, ["email"])
    Concierge.Utils.changeset(cleaned_up_parameters)
  end
end