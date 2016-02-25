# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixBlog.Repo.insert!(%PhoenixBlog.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
changeset = PhoenixBlog.User.create_changeset(%PhoenixBlog.User{},
 %{first_name: "Joe",
  last_name: "Doe",
  email: "admin@example.com",
  password: "12345678",
  password_confirmation: "12345678"})
  
PhoenixBlog.Repo.insert!(changeset)
