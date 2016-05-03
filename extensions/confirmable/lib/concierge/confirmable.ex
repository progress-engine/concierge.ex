defmodule Concierge.Confirmable do
  @behaviour Concierge.Resource.Registration.Callbacks
  @behaviour Concierge.Resource.Session.Callbacks

  def before_create(_), do: true

  def after_create(resource) do
    Confirmable.Confirmation.send_to(resource) 
  end

  def before_sign_in(resource) do
    case Confirmable.Resource.confirmed?(resource) do
      true -> :ok
      false -> throw({:error, "You should confirm your account"})
    end
  end

  def after_sign_in(_), do: true
end