defmodule Recoverable.Endpoint do
  use Phoenix.Endpoint, otp_app: :recoverable

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_concierge_key",
    signing_salt: "AagQZfli"

  plug Recoverable.TestRouter
end