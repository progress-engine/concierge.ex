defmodule Concierge.DummySerializer do
  @behaviour Guardian.Serializer
  @moduledoc """
  Dummy serializer for Guardian
  """

  def for_token(_), do: { :ok, "" }
  def from_token(_), do: { :ok, "" }
end