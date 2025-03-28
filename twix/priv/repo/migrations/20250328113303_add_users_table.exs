defmodule Twix.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      add :email, :string
      add :age, :integer

      timestamps()
    end

    #NAO PODE SER ASSIM, para evitar que name e email sejam nulos
    #create unique_index(:users, [nickname, email])
    create unique_index(:users, [nickname])
    create unique_index(:users, [email])
  end
end
