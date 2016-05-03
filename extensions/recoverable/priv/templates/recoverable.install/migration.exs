defmodule <%= base %>.Repo.Migrations.AddRecoverableTo<%= scoped %> do
  use Ecto.Migration

  def change do
    alter table(:<%= plural %>) do
      add :reset_password_token, :string
      add :reset_password_token_sent_at, :datetime
    end
    create unique_index(:<%= plural %>, [:reset_password_token])
  end
end
