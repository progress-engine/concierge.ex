defmodule Recoverable.TestUser do
  use Concierge.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :reset_password_token, :string
    field :reset_password_token_sent_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(email password password_confirmation)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_format(:email, email_regexp)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp email_regexp, do: ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/
end