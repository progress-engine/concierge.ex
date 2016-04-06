defmodule <%= base %>.Repo.Migrations.AddConfirmableTo<%= scoped %> do
  use Ecto.Migration

  def change do
    alter table(:<%= plural %>) do
      add :confirmation_token, :string
      add :confirmation_sent_at, :datetime
      add :confirmed_at, :datetime
    end
    create unique_index(:<%= plural %>, [:confirmation_token])
  end
end
