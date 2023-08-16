export default [
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
      {
        "line-color": "#c2a5cf",
        "line-width": 3,
        "line-dasharray": [1, 1],
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
