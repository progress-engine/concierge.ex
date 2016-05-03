defmodule Concierge.Resource do  
  @moduledoc """
  A set of functions to work with concierge resource.
  """

  @doc """
  Fetch resource by authentication key (email)
  """
  def get_by_authentication_key(authentication_key) do
    get_by(email: authentication_key)
  end

  @doc """
  Fetch resource by parameters
  """
  def get_by(params) do
    Concierge.repo.get_by(Concierge.resource, params)
  end

  @doc """
  Encrypts password and put it to `encrypted_password` field
  """
  def put_encrypted_password(changeset) do
    encrypted_password = Comeonin.Bcrypt.hashpwsalt(changeset.params["password"])

    changeset 
    |> Ecto.Changeset.put_change(:encrypted_password, encrypted_password)
  end

  @doc """
  Verifies whether a password (ie from sign in) is matches the resource's password.
  """
  def valid_password?(nil, _), do: false
  def valid_password?(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
  end
end
