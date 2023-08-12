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

  def panel_classes() do
    style = [
      "bg-white",
      "shadow",
      "p-7",
      "fixed",
      "z-20",
      "ease-in-out",
      "duration-300",
      "overflow-y-auto"
    ]

    desktop = [
      "md:top-0",
      "md:right-0",
      "md:w-[400px]",
      "md:h-full"
    ]

    mobile = [
      "bottom-0",
      "right-0",
      "w-full",
      "h-[300px]"
    ]

    style ++ desktop ++ mobile
  end

  def panel_button_classes() do
    style = [
      # "p-3",
      "font-xl",
      "border",
      "text-slate-300",
      "font-semibold",
      "rounded-lg",
      "bg-white",
      "fixed",
      "z-40",
      "ease-in-out",
      "duration-300",
      "w-12",
      "h-12",
      "p-0",
      "flex",
      "items-center",
      "justify-center"
    ]

    mobile = [
      "bottom-[275px]",
      "right-[47%]",
      "-rotate-90"
    ]

    desktop = [
      "md:top-1/2",
      "md:right-[385px]",
      "md:rotate-180",
      "md:bottom-auto"
    ]

    style ++ desktop ++ mobile
  end

  def render(assigns) do
    ~H"""
    <button id="slideout-button" class={panel_button_classes()} phx-click={toggle_panel()}>
      <SafeBikeRoutesWeb.CoreComponents.icon name="hero-chevron-left" />
    </button>
    <div id="slideout" class={panel_classes()}>
      <div class="text-xl font-medium text-black">Safe Bike Routes: LA</div>
      <p class="text-slate-500">
        Because Google Maps Bike Routes are ass and I don't want to die.
      </p>
      <p class="py-5">
        These routes were made by me to get around the parts of LA I
        generally travel around using both personal experience and google maps
        satellite and street views. If you notice anything wrong with them or
        would like to suggest new routes to add, please check out the <a
          class="underline decoration-sky-600 hover:decoration-blue-400"
          href="https://forms.gle/xcFbpyW1iK7D7D598"
        >google form</a>!
      </p>
      <div class="text-l font-medium">Legend</div>
      <ul class="list-disc px-5">
        <li>
          <span class="font-bold underline">black</span>: routes follow all of the rules
          laid out below
        </li>
        <li>
          <span class="font-bold underline text-orange-500">dashed orange</span>: routes
          are intended to be ridden on the sidewalk and only used to connect major
          routes that would otherwise fall under black
        </li>
      </ul>
      <div class="pt-5 text-l font-medium">The Rules</div>
      <ul class="list-disc px-5">
        <li>sharrows only allowed on narrow residential streets</li>
        <li>bicycle gutters only allowed on 2 lane roads</li>
        <li>
          if it's any wider than two lanes (including center turn lane) it
          must be somehow physically separated
        </li>
        <li>
          routes should strive to be as contiguous as possible, cross multiple
          arterials exclusively at signalized intersections, and provide safe
          routes across freeway boundaries
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
