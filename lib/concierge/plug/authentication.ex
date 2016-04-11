defmodule Concierge.Plug.Authentication do
  @moduledoc """
  """

  @doc false
  def init(opts \\ %{}), do: Enum.into(opts, %{})

  @doc false
  def call(conn, opts) do
    conn 
      |> Guardian.Plug.VerifySession.call(opts)
      |> Guardian.Plug.LoadResource.call(opts)
  end
end