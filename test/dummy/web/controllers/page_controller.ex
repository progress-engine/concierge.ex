defmodule Dummy.PageController do
  use Dummy.Web, :controller

  ensure_authenticated! only: [:protected]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def protected(conn, _params) do
    render conn, "protected.html"
  end
end
