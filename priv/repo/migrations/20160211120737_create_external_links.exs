defmodule PhoenixBlog.Repo.Migrations.CreateExternalLinks do
  use Ecto.Migration

  def change do
    create table(:post_links) do
      add :post_id, references(:posts)
      add :title, :string
      add :link, :string

      timestamps
    end

  end
end
