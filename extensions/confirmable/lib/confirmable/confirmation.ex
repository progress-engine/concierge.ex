defmodule Confirmable.Confirmation do
  @moduledoc """
  """

  @doc """
  Generate confirmation token and send email to user
  """
  def send_to(resource) do
    case Confirmable.send_confirmation? do
      true ->         
        {:ok, datetime} = Ecto.DateTime.cast(:calendar.universal_time())
        Ecto.Changeset.change(resource, 
            confirmation_sent_at: datetime, 
            confirmation_token: generate_confirmation_token)
          |> Concierge.repo.update!
          |> send_confirmation_email
      _ -> :ok  
    end
  end

  @doc false
  defp send_confirmation_email(resource) do
    url = Concierge.route_helpers.confirmation_url(Concierge.endpoint, :show, email: resource.email, confirmation_token: resource.confirmation_token)

    Confirmable.mailer.send_confirmation_email(resource, url)
  end

  @doc false
  defp generate_confirmation_token(length \\ 32) do
    :crypto.strong_rand_bytes(length) 
      |> Base.url_encode64 
      |> binary_part(0, length)
  end
end