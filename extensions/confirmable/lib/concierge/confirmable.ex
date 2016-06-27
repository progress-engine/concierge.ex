defmodule Concierge.Confirmable do
  @behaviour Concierge.Resource.Registration.Callbacks
  @behaviour Concierge.Resource.Session.Callbacks

  def before_create(_), do: {:ok}

  def after_create(resource) do
    Confirmable.Confirmation.send_to(resource) 
    {:ok}
  end

  def before_sign_in(_, resource) do
    if Confirmable.Resource.confirmed?(resource) do
      {:ok}
    else
      {:error, "You should confirm your account"}
    end
  end

  def after_sign_in(_), do: {:ok}
end