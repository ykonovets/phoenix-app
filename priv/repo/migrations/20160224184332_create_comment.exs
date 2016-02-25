defmodule PhoenixBlog.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :text, null: false
      add :user_id, :integer, null: false
      add :post_id, :integer, null: false

      timestamps
    end
  end
end
