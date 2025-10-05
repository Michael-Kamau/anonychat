defmodule Anonychat.Repo do
  use Ecto.Repo,
    otp_app: :anonychat,
    adapter: Ecto.Adapters.Postgres
end
