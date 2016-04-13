defmodule Confirmable.Endpoint do
  use Phoenix.Endpoint, otp_app: :confirmable

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

  plug Confirmable.TestRouter
end