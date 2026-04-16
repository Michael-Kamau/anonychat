defmodule Anonychat.ReleaseMigrator do
  @app :my_app

  def migrate do
    {:ok, _} = Application.ensure_all_started(@app)
    for repo <- Application.fetch_env!(@app, :ecto_repos) do
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end
end
