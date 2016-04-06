defmodule Dummy.Repo.Migrations.AddConfirmableToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmation_token, :string
      add :confirmation_sent_at, :datetime
      add :confirmed_at, :datetime
    end
    create unique_index(:users, [:confirmation_token])
  end
end
