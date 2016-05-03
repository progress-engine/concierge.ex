defmodule Concierge.Recoverable.Routes do
  @moduledoc """
  Routes extensions for Concierge
  """
  
  def routes do
    quote do 
      resources "/passwords", Recoverable.PasswordController, only: [:new, :create, :edit, :update], singleton: true
    end
  end
end