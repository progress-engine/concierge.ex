defmodule Confirmable.Resource do

  def confirm!(email, confirmation_token) do
    find_resource(email, confirmation_token)   
      |> do_confirmation
  end

  defp find_resource(email, confirmation_token) do    
    Concierge.repo.get_by(resource, email: email, confirmation_token: confirmation_token)
  end

  defp do_confirmation(nil) do
    {:error}        
  end
  defp do_confirmation(resource) do
    case confirmed?(resource) do
      true -> {:ok, resource}
      false ->
        {:ok, datetime} = Ecto.DateTime.cast(:calendar.universal_time())
        Ecto.Changeset.change(resource, %{confirmed_at: datetime})
          |> Concierge.repo.update
    end
  end

  def confirmed?(nil), do: false
  def confirmed?(resource) do
    !is_nil(resource.confirmed_at)
  end

  defp resource, do: Concierge.resource
end