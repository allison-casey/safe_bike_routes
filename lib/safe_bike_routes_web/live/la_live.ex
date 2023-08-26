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
    |> JS.dispatch("resize")
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

  def control_panel(assigns) do
    ~H"""
    <button id="slideout-button" class={panel_button_classes()} phx-click={toggle_panel()}>
      <SafeBikeRoutesWeb.CoreComponents.icon name="hero-chevron-left" />
    </button>
    <div class="p-5 overflow-y-auto">
      <div class="text-xl font-medium text-black">Safe Bike Routes: LA</div>
      <p class="text-slate-500">
        Because Google Maps Bike Routes are ass and we don't want to die.
      </p>
      <p class="py-5">
        Safe Bike Routes is a community project to document the ways to get
        around Los Angeles by bike with as little risk as possible. The only
        reason this project exists, is because of the abject failure of Los
        Angeles and other unincorporated cities in the area to treat people on
        bicycles as human beings worthy of a life of dignity. The status quo is
        not okay, and we should all raise our voices for a better Los Angeles.
        Until then though, we hope this map helps you make the most of life on
        two wheels in this city. It can be a beautiful, liberating, and
        empowering experience that opens your eyes to this city and it's people.
      </p>
      <p class="py-5">
        These routes are a crowdsourced effort drawn from personal experience
        and satelite imagery. If you notice anything wrong with them or would
        like to suggest new routes to add, please check out the <a
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
      <a
        href="https://github.com/allison-casey/safe_bike_routes"
        class="group relative rounded-2xl px-3 w-32 my-5 mx-auto ext-sm font-semibold leading-6 text-slate-500 sm:py-3"
      >
        <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
        </span>
        <span class="relative flex items-center sm:flex-col">
          <svg viewBox="0 0 24 24" aria-hidden="true" class="h-4 w-4">
            <path
              fill-rule="evenodd"
              clip-rule="evenodd"
              d="M12 0C5.37 0 0 5.506 0 12.303c0 5.445 3.435 10.043 8.205 11.674.6.107.825-.262.825-.585 0-.292-.015-1.261-.015-2.291C6 21.67 5.22 20.346 4.98 19.654c-.135-.354-.72-1.446-1.23-1.738-.42-.23-1.02-.8-.015-.815.945-.015 1.62.892 1.845 1.261 1.08 1.86 2.805 1.338 3.495 1.015.105-.8.42-1.338.765-1.645-2.67-.308-5.46-1.37-5.46-6.075 0-1.338.465-2.446 1.23-3.307-.12-.308-.54-1.569.12-3.26 0 0 1.005-.323 3.3 1.26.96-.276 1.98-.415 3-.415s2.04.139 3 .416c2.295-1.6 3.3-1.261 3.3-1.261.66 1.691.24 2.952.12 3.26.765.861 1.23 1.953 1.23 3.307 0 4.721-2.805 5.767-5.475 6.075.435.384.81 1.122.81 2.276 0 1.645-.015 2.968-.015 3.383 0 .323.225.707.825.585a12.047 12.047 0 0 0 5.919-4.489A12.536 12.536 0 0 0 24 12.304C24 5.505 18.63 0 12 0Z"
              fill="#18181B"
            />
          </svg>
          Source Code
        </span>
      </a>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen grid grid-rows-[1fr_auto] md:grid-rows-1 md:grid-cols-[1fr_auto]">
      <div>
        <div id="map" class="z-10 h-full w-full relative" phx-hook="Map" phx-update="ignore" />
      </div>
      <div
        id="slideout"
        class="z-40 bg-white shadow overflow-y-auto transition-all h-[300px] md:w-[400px] md:h-auto"
      >
        <.control_panel />
      </div>
    </div>
    """
  end

  def handle_event("map_loaded", _value, socket) do
    {:noreply, push_event(socket, "load_routes", %{routes: @la_routes})}
  end
end
