defmodule <%= base %>.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias <%= base %>.Repo
  alias <%= module %>

  def for_token(<%= singular %> = %<%= scoped %>{}), do: { :ok, "<%= scoped %>:#{<%= singular %>.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("<%= scoped %>:" <> id), do: { :ok, Repo.get(<%= scoped %>, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end