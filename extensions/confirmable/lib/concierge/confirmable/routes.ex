defmodule Concierge.Confirmable.Routes do

  def routes do
    quote do 
      get "/confirmations", Confirmable.ConfirmationController, :show
    end
  end
end