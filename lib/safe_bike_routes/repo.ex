defmodule SafeBikeRoutes.Repo do
  use Ecto.Repo,
    otp_app: :safe_bike_routes,
    adapter: Ecto.Adapters.Postgres
end
