defmodule SafeBikeRoutesWeb.LALive do
  use SafeBikeRoutesWeb, :live_view

  @la_routes Application.app_dir(:safe_bike_routes, "priv/static/map.json")
             |> File.read!()
             |> Poison.decode!()

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def toggle_panel(js \\ %JS{}) do
    js
    |> JS.remove_class("off", to: "#slideout.off")
    |> JS.add_class("off", to: "#slideout:not(.off)")
    |> JS.remove_class("off", to: "#slideout-button.off")
    |> JS.add_class("off", to: "#slideout-button:not(.off)")
  end

  def render(assigns) do
    ~H"""
    <button
      id="slideout-button"
      class="p-3 font-xl border text-slate-300 font-semibold rounded-lg bg-white"
      phx-click={toggle_panel()}
    >
      &lt;
    </button>
    <div id="slideout" class="bg-white shadow p-6">
      <div class="text-xl font-medium text-black">Safe Bike Routes: LA</div>
      <p class="text-slate-500">Because Google Maps Bike Routes are ass and I don't want to die.</p>
      <p class="py-5">
        These routes were made by me to get around the parts of LA I generally travel around using both personal experience and google maps satellite and street views. If you notice anything wrong with them or would like to suggest new routes to add, please check out the <a
          class="underline decoration-sky-600 hover:decoration-blue-400"
          href="https://forms.gle/xcFbpyW1iK7D7D598"
        >google form</a>!
      </p>
      <div class="text-l font-medium">Legend</div>
      <ul class="list-disc px-5">
        <li>
          <span class="font-bold underline">black</span>: routes follow all of the rules laid out below
        </li>
        <li>
          <span class="font-bold underline text-orange-500">dashed orange</span>: routes are intended to be ridden on the sidewalk and only used to connect major routes that would otherwise fall under black
        </li>
      </ul>
      <div class="pt-5 text-l font-medium">The Rules</div>
      <ul class="list-disc px-5">
        <li>sharrows only allowed on narrow residential streets</li>
        <li>bicycle gutters only allowed on 2 lane roads</li>
        <li>
          if it's any wider than two lanes (including center turn lane) it must be somehow physically separated
        </li>
        <li>
          routes should strive to be as contiguous as possible, cross multiple arterials exclusively at signalized intersections, and provide safe routes across freeway boundaries
        </li>
        <li>everything else is ass and LADOT should get their shit together</li>
      </ul>
    </div>
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
