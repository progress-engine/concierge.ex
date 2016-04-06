defmodule Concierge.Confirmable.Routes do

  def routes do
    quote do 
      get "/confirmations", Confirmable.ConfirmationsController, :show
    end
  end
end