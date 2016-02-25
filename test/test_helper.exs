ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhoenixBlog.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixBlog.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixBlog.Repo)

