defmodule Concierge.Mailer do
  defmacro __using__(_options) do
    quote do 
      use Mailgun.Client, Concierge.mailer_options      
    end
  end
end