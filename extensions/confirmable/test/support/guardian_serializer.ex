defmodule Confirmable.GuardianTestSerializer do
  @behaviour Guardian.Serializer

  alias Confirmable.TestRepo
  alias Confirmable.TestUser

  def for_token(user = %TestUser{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, TestRepo.get(TestUser, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end