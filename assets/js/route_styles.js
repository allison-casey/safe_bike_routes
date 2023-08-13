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
        "line-color": "#2daed6",
        "line-width": 3,
        "line-dasharray": [1, 1],
      },
    ],
  },
  {
    routeType: "lane",
    paintLayers: [
      {
        "line-color": "#2a97b8",
        "line-width": 3,
      },
    ],
  },
  {
    routeType: "protected",
    paintLayers: [
      {
        "line-color": "black",
        "line-width": 2,
        "line-gap-width": 2,
        "line-dasharray": [4, 4],
      },
      {
        "line-color": "#2a97b8",
        "line-width": 3,
      },
    ],
  },
  {
    routeType: "track",
    paintLayers: [
      {
        "line-color": "black",
        "line-width": 2,
        "line-gap-width": 2,
      },
      {
        "line-color": "#2a97b8",
        "line-width": 3,
      },
    ],
  },
];
