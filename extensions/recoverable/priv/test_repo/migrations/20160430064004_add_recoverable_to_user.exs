defmodule Dummy.Repo.Migrations.AddRecoverableToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reset_password_token, :string
      add :reset_password_token_sent_at, :datetime
    end
    create unique_index(:users, [:reset_password_token])
  end
end
