defmodule Piruet.Repo do
  use Ecto.Repo,
    otp_app: :piruet,
    adapter: Ecto.Adapters.Postgres
end
