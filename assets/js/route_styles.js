export const routeStyles = [
  {
    routeType: "sidewalk",
    paintLayers: [
      { "line-width": 3 },
      {
        "line-color": "yellow",
        "line-width": 3,
        "line-dasharray": [3, 2],
      },
    ],
  },
  {
    routeType: "street",
    paintLayers: [
      { "line-width": 3, "line-color": "white" },
      {
        "line-color": "#c2a5cf",
        "line-width": 3,
        "line-dasharray": [2, 1],
      },
    ],
  },
  {
    routeType: "lane",
    paintLayers: [
      {
        "line-color": "#c2a5cf",
        "line-width": 3,
      },
    ],
  },
  {
    routeType: "protected",
    paintLayers: [
      {
        "line-color": "#7b3294",
        "line-width": 5,
      },
      {
        "line-color": "white",
        "line-width": 2,
        "line-gap-width": 5,
      },
    ],
  },
  {
    routeType: "track",
    paintLayers: [
      {
        "line-color": "#008837",
        "line-width": 5,
      },
      {
        "line-color": "white",
        "line-width": 2,
        "line-gap-width": 5,
      },
    ],
  },
];

export const legacyRouteStyles = [
  {
    routeType: "sidwalk",
    paintLayers: [
      {
        "line-color": "orange",
        "line-width": 5,
        "line-dasharray": [2, 1],
      },
    ],
  },
  { routeType: "street", paintLayers: [{}] },
  { routeType: "lane", paintLayers: [{}] },
  { routeType: "protected", paintLayers: [{}] },
  { routeType: "track", paintLayers: [{}] },
];

export function paintRoute(map, source, routeType, paintLayers) {
  for (const [index, paintLayer] of paintLayers.entries()) {
    map.addLayer({
      id: `${source}-${routeType}-${index}`,
      type: "line",
      source: source,
      filter: ["==", "routeType", routeType],
      paint: paintLayer,
    });
  }
}
