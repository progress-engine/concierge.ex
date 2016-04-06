defmodule Concierge.Routes do
  defmacro __using__(_opts) do
    quote do
      import Concierge.Routes
    end
  end

  defmacro concierge(opts) do
    pipes = Keyword.get(opts, :pipe_through, [])
    at = Keyword.get(opts, :at, "users")
    quote do
      scope "/#{unquote(at)}", Concierge do
        pipe_through unquote(pipes)

        get "sign_in", SessionsController, :new
        post "sign_in", SessionsController, :create
        delete "sign_out", SessionsController, :destroy

        get "sign_up", RegistrationsController, :new
        post "sign_up", RegistrationsController, :create

        unquote(append_extensions_routes!)
      end
    end
  end

  defp append_extensions_routes! do
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
