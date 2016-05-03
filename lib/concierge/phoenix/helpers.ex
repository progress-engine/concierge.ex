defmodule Concierge.Helpers do
  @moduledoc """
  Defines `current_user` and `user_signed_in?` helpers
  """
  defmacro __using__(_) do
    quote do
      def unquote(:"current_#{Concierge.resource_name}")(conn) do
        Guardian.Plug.current_resource(conn)
      end

      def unquote(:"#{Concierge.resource_name}_signed_in?")(conn) do
        Guardian.Plug.current_resource(conn) != nil
      end
    end
  end
end