defmodule Confirmable do
  def send_confirmation?, do: config(:send_confirmation, true)
  def mailer, do: config(:mailer, Confirmable.Mailer)
  def email_view, do: config(:email_view, Confirmable.EmailView)

  @doc false
  defp config(key), do: config_entry(key)
  @doc false
  defp config(key, default), do: config_entry(key, default)

  defp config_entry(key), do: config_entry(key, nil)
  defp config_entry(key, default) do
    config = Application.get_env(:concierge, Concierge.Confirmable)
    case config do
      nil -> default
      _ -> Keyword.get(config, key, default)
    end    
  end
end
