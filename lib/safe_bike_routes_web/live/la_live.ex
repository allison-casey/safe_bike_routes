defmodule SafeBikeRoutesWeb.LALive do
  use SafeBikeRoutesWeb, :live_view

  @la_routes Application.app_dir(:safe_bike_routes, "priv/static/assets/map.json")
             |> File.read!()
             |> Poison.decode!()

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div
      id="map"
      phx-hook="Map"
      phx-update="ignore"
      style="position: absolute; top: 0; bottom: 0; left: 0; width: 100%;"
    />
    """
  end

  def handle_event("map_loaded", _value, socket) do
    {:noreply, push_event(socket, "load_routes", %{routes: @la_routes})}
  end
end
