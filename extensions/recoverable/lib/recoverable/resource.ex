defmodule Recoverable.Resource do
  
  @doc """
  Update password on resource and clear reset password token
  """
  def reset_password(resource, new_password, new_password_confirmation) do    
    changeset = Concierge.resource.changeset(resource, %{password: new_password, password_confirmation: new_password_confirmation})
    
    changeset
    |> Concierge.Resource.put_encrypted_password
    |> Ecto.Changeset.put_change(:reset_password_token, nil)
    |> Concierge.repo.update
  end

  @doc """
  Update password token and send instructions by email
  """
  def send_reset_password_instructions(nil), do: :error
  def send_reset_password_instructions(resource) do
    token = Concierge.Utils.generate_token

    Concierge.repo.transaction fn -> 
      resource 
      |> update_reset_password_token(token)
      |> update_sent_time 
      |> send_reset_password_instructions_email(token)
    end

    :ok
  end

  @doc """
  Send email with password reset notification
  """
  def send_reset_password_instructions_email(resource, token) do
    url = Concierge.route_helpers.password_url(Concierge.endpoint, :edit, 
      email: resource.email, reset_password_token: token)

    Recoverable.mailer.send_reset_password_notification(resource, url)
  end

  @doc false
  defp update_reset_password_token(resource, token) do
    update!(resource, %{reset_password_token: token})
  end

  @doc false
  defp update_sent_time(resource) do
    {:ok, datetime} = Ecto.DateTime.cast(:calendar.universal_time())
    update!(resource, %{reset_password_token_sent_at: datetime})
  end

  @doc false
  defp update!(resource, params = %{}) do
    changeset = Ecto.Changeset.change(resource, params)
    Concierge.repo.update!(changeset) 
  end
end