export default [
  {
    routeType: "sidewalk",
    paintLayers: [
      {
        "line-color": "orange",
        "line-width": 5,
        "line-dasharray": [2, 2],
      },
    ],
  },
  { routeType: "street", paintLayers: [{}] },
  {
    routeType: "lane",
    paintLayers: [
      {
        "line-color": "blue",
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
        "line-dasharray": [2, 2],
      },
      {
        "line-color": "yellow",
        "line-width": 2,
      },
    ],
  },
  {
    routeType: "track",
    paintLayers: [
      {
        "line-color": "yellow",
        "line-width": 5,
      },
      {
        "line-color": "black",
        "line-width": 2,
        "line-gap-width": 5,
      },
    ],
  },
];
