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
        IO.inspect Confirmable.ttl
        {:ok, send_at} = Ecto.DateTime.cast(resource.confirmation_sent_at)
        IO.inspect send_at
        case greater_than_ttl_days?(Ecto.DateTime.to_erl(send_at), Ecto.DateTime.to_erl(datetime)) do 
          true -> {:error_expired_ttl}
          false -> 
            Ecto.Changeset.change(resource, %{confirmed_at: datetime})
            |> Concierge.repo.update
        end
    end
  end

  @doc """
  Verifies if date A is greater than date B by TTL days or not
  """
  def greater_than_ttl_days?(a, b) do
    min = Confirmable.ttl * 24 * 60 * 60
    (:calendar.datetime_to_gregorian_seconds(b) -
     :calendar.datetime_to_gregorian_seconds(a)) >= min
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