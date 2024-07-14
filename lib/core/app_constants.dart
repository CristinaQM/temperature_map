import 'package:flutter/material.dart';

const String mapBoxAccessToken = 'pk.eyJ1IjoiY2VxdWludGUiLCJhIjoiY2xuZ3hoZnMxMGllcjJrbzJkaWoxbXg3aCJ9.Fwsq4U7cEKHxiF0XAigDdg';

const String urlTemplate = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapBoxAccessToken';

const String mapBoxStyleStreets = 'mapbox/streets-v12';
const String mapBoxStyleOutdoors = 'mapbox/outdoors-v12';
const String mapBoxStyleLight = 'mapbox/light-v11';
const String mapBoxStyleDark = 'mapbox/dark-v11';

const String urlSrc = 'sensorDataNuevoMariaIsabel';

const double altaTemperatura = 31;
const double maxTempAmbiente = 27;

const Color altoColor = Color(0xFFFC5B4F);
const Color medioColor = Color(0xFFFFD24A);
const Color bajoColor = Color(0xFF41F388);

const Color altoStrokeColor = Color.fromARGB(255, 179, 52, 42);
const Color medioStrokeColor = Color.fromARGB(255, 216, 154, 31);
const Color bajoStrokeColor = Color.fromARGB(255, 31, 148, 88);
