defmodule Concierge.Routes do
  @moduledoc """
  Set of route extensions used by main application
  """

  defmacro __using__(_opts) do
    quote do
      import Concierge.Routes
    end
  end

  @doc """
  Includes concierge method for routes. 
  This method is responsible to generate all needed routes for concierge
  """
  defmacro concierge(opts) do
    pipes = Keyword.get(opts, :pipe_through, [])
    at = Keyword.get(opts, :at, "users")
    quote do
      scope "/#{unquote(at)}", Concierge do
        pipe_through unquote(pipes)

        get "sign_in", SessionController, :new
        post "sign_in", SessionController, :create
        delete "sign_out", SessionController, :destroy

        get "sign_up", RegistrationController, :new
        post "sign_up", RegistrationController, :create

        unquote(extension_routes)
      end
    end
  end

  defp extension_routes do    
    Enum.map Concierge.extensions, fn(extension) ->
      try do
        extension_routes = Module.safe_concat(extension, Routes)
        extension_routes.routes 
      rescue 
        ArgumentError -> nil
      end  
    end
  end
end
