defmodule Concierge do
  def otp_app, do: config(:otp_app)

  def resource, do: config(:resource, app_module("User"))
  def repo, do: config(:repo, app_module("Repo"))
  def resource_name, do: config(:resource_name, "user")
  def route_helpers, do: config(:route_helpers, app_module("Router.Helpers"))
  def endpoint, do: config(:endpoint, app_module("Endpoint"))
  def gettext, do: config(:gettext, app_module("Gettext"))
  def error_helpers, do: config(:error_helpers, app_module("ErrorHelpers"))

  def sender_address, do: config(:sender_address, "change-me@email.com")
  def mailer_options, do: config(:mailer_options, [mode: :test, test_file_path: "/tmp/mailgun.json", domain: "", key: ""])

  def extensions, do: config(:extensions, [])

  def auth_error_handler, do: config(:auth_error_handler, Concierge.Controller.AuthErrorHandler)

  def layout do
    config(:layout, {app_module("LayoutView"), "app.html"})
  end

  @doc false
  def config(key), do: config_entry(key)
  @doc false
  def config(key, default), do: config_entry(key, default)

  defp config_entry(key), do: config_entry(key, nil)
  defp config_entry(key, default) do
    config = Application.get_env(:concierge, Concierge)
    case config do
      nil -> raise "Concierge is not configured"
      _ -> Keyword.get(config, key, default)
    end    
  end

  defp app_module(module_name) do
    if otp_app do
      :"#{otp_app}.#{module_name}"
    else
      raise "Some of :otp_app or module names should be defined"
    end
  end
end
