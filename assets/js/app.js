// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import mapboxgl from "mapbox-gl";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";

let Hooks = {};

Hooks.Map = {
  initMap() {
    const bounds = [
      [-118.88065856936811, 33.63722119725411], // Southwest coordinates
      [-117.83375850298786, 34.4356118682199], // Northeast coordinates
    ];

    mapboxgl.accessToken =
      "pk.eyJ1IjoiYWxsaXNvbi1jYXNleSIsImEiOiJjbGt5Y2puaDExOTJ2M2dvODk3YmtvZ2RsIn0.c_wjxvRq0S2Nv58mxfStyg";
    var map = new mapboxgl.Map({
      container: "map",
      style: "mapbox://styles/mapbox/streets-v11",
      center: [-118.35874251099995, 34.061734936928694],
      maxBounds: bounds,
      zoom: 12,
    });

    map.addControl(
      new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        mapboxgl: mapboxgl,
        marker: true,
        bbox: bounds.flat(),
      }),
      "top-right",
    );

    // Add geolocate control to the map.
    map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true,
        },
        // When active the map will receive updates to the device's location as it changes.
        trackUserLocation: true,
        // Draw an arrow next to the location dot to indicate which direction the device is heading.
        showUserHeading: true,
      }),
      "top-left",
    );

    map.on("load", () => {
      this.pushEvent("map_loaded", {});
    });

    // fix for map canvas not resizing when css grid changes
    const debounce = (func, delay) => {
      let debounceTimer;
      return function () {
        const context = this;
        const args = arguments;
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => func.apply(context, args), delay);
      };
    };

    // this 150ms matches the transition of the control panel
    const resizer = new ResizeObserver(debounce(() => map.resize(), 150));
    resizer.observe(map.getContainer());

    this.handleEvent("load_routes", ({ routes }) => {
      map.addSource("saferoutesla", {
        type: "geojson",
        data: routes,
      });
      map.addLayer({
        id: "saferoutesla-standard",
        type: "line",
        source: "saferoutesla",
        filter: ["!=", "routeType", "sidewalk"],
      });

      map.addLayer({
        id: "saferoutesla-sidewalk",
        type: "line",
        source: "saferoutesla",
        filter: ["==", "routeType", "sidewalk"],
        paint: {
          "line-color": "orange",
          "line-width": 5,
          "line-dasharray": [2, 1],
        },
      });
    });
  },

  mounted() {
    this.initMap();
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
