defmodule Confirmable.Resource do
  @moduledoc """
  Holds function to perform confirmation on resource
  """

  @doc """
  Find resource by its credentials and confirm it by setting it's confirmed_at to actual time
  """
  def confirm!(email, confirmation_token) do
    find_resource(email, confirmation_token)   
    |> confirm!
  end
  def confirm!(nil) do
    {:error}        
  end
  def confirm!(resource) do
    case confirmed?(resource) do
      true -> {:ok, resource}
      false ->
        {:ok, datetime} = Ecto.DateTime.cast(:calendar.universal_time())
        Ecto.Changeset.change(resource, %{confirmed_at: datetime})
          |> Concierge.repo.update
    end
  end

  @doc """
  Verifies whether a resource is confirmed or not
  """
  def confirmed?(nil), do: false
  def confirmed?(resource) do
    !is_nil(resource.confirmed_at)
  end

  @doc false
  defp find_resource(email, confirmation_token) do    
    Concierge.Resource.get_by(email: email, confirmation_token: confirmation_token)
  end

  @doc false
  defp resource, do: Concierge.resource
end