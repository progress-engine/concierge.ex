defmodule Recoverable do
  def mailer, do: config(:mailer, Recoverable.Mailer)
  def email_view, do: config(:email_view, Recoverable.EmailView)

  # TODO separate module
  @doc false
  defp config(key), do: config_entry(key)
  @doc false
  defp config(key, default), do: config_entry(key, default)

  defp config_entry(key), do: config_entry(key, nil)
  defp config_entry(key, default) do
    config = Application.get_env(:concierge, Concierge.Recoverable)
    case config do
      nil -> default
      _ -> Keyword.get(config, key, default)
    end    
  end
end
