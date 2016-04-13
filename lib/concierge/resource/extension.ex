defmodule Concierge.Extension do
  @moduledoc """
  """

  @callback before_create(Ecto.Changeset.t) :: any
  @callback after_create(Ecto.Schema.t) :: any

  @callback before_sign_in(Ecto.Schema.t) :: any
  @callback after_sign_in(Ecto.Schema.t) :: any
end