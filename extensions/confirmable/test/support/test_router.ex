defmodule Confirmable.TestRouter do
  use Concierge.Web, :router
  use Concierge.Routes

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  concierge at: "users", pipe_through: [:browser]
end