defmodule Concierge.Confirmable do
  use Concierge.Extension

  after_create fn(resource) -> 
    Confirmable.Confirmation.send_to(resource) 
  end

  before_sign_in fn(resource) ->
    case Confirmable.Resource.confirmed?(resource) do
      true -> :ok
      false -> throw({:error, "You should confirm your account"})
    end
  end
end