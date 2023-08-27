import { debounce } from "./utils";
import mapboxgl from "mapbox-gl";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";
import { paintRoute, routeStyles, legacyRouteStyles } from "./route_styles";

const BOUNDS = [
  [-118.88065856936811, 33.63722119725411], // Southwest coordinates
  [-117.83375850298786, 34.4356118682199], // Northeast coordinates
];
const CENTER = [-118.35874251099995, 34.061734936928694];
const USE_LEGACY_ROUTE_STYLES = true;
const DEFAULT_MAP_STYLE = "Streets";
const MAP_STYLES = [
  {
    title: "Streets",
    style: "mapbox://styles/mapbox/streets-v12",
  },
  {
    title: "Satellite Streets",
    style: "mapbox://styles/mapbox/satellite-streets-v12",
  },
];

function addGeocoder(map, bounds, location) {
  map.addControl(
    new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      marker: true,
      bbox: bounds.flat(),
    }),
    location,
  );
}

function addGeolocation(map, location) {
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
    location,
  );
}

/**
 * Create a `ResizeObserver` to watch the map container for resize events this
 * is necesary because the map sometimes wont update its width/height when the
 * control panel opens and closes.
 */
function initResizeObserver(map) {
  // this 150ms matches the transition of the control panel
  const resizer = new ResizeObserver(debounce(() => map.resize(), 150));
  resizer.observe(map.getContainer());
}

function loadRoutes(map, routes) {
  if (!map.safe_routes) return;
  map.addSource("saferoutesla", {
    type: "geojson",
    data: routes,
  });

  // waiting for all the routes to categorized correctly before switching this
  // over to the new route styles
  const styles = USE_LEGACY_ROUTE_STYLES ? legacyRouteStyles : routeStyles;
  for (const { routeType, paintLayers } of styles) {
    paintRoute(map, "saferoutesla", routeType, paintLayers);
  }
}

const handleLoadRoutesEvent =
  (map) =>
  ({ routes }) => {
    map.safe_routes = routes;
    loadRoutes(map, map.safe_routes);
  };

const handleMapStyleChangeEvent =
  (map) =>
  ({ styleName }) => {
    const style = MAP_STYLES.find((d) => d.title === styleName).style;
    map.setStyle(style);
  };

export function initMap() {
  mapboxgl.accessToken =
    "pk.eyJ1IjoiYWxsaXNvbi1jYXNleSIsImEiOiJjbGt5Y2puaDExOTJ2M2dvODk3YmtvZ2RsIn0.c_wjxvRq0S2Nv58mxfStyg";

  const map = new mapboxgl.Map({
    container: "map",
    style: MAP_STYLES.find((d) => d.title === DEFAULT_MAP_STYLE).style,
    center: CENTER,
    maxBounds: BOUNDS,
    zoom: 12,
  });

  initResizeObserver(map);
  addGeocoder(map, BOUNDS, "top-right");
  addGeolocation(map, "top-left");

  // Map Events
  //// tell server the canvas has been initiated
  map.on("load", () => this.pushEvent("map_loaded", {}));
  map.on("style.load", () => loadRoutes(map, map.safe_routes));

  // Server Event Handlers
  //// server will respond with the json routes to paint after map has loaded
  this.handleEvent("load_routes", handleLoadRoutesEvent(map));
  this.handleEvent("set_map_style", handleMapStyleChangeEvent(map));
}
