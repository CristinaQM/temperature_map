import 'package:flutter/material.dart';

const String mapBoxAccessToken = 'pk.eyJ1IjoiY2VxdWludGUiLCJhIjoiY2xuZ3hoZnMxMGllcjJrbzJkaWoxbXg3aCJ9.Fwsq4U7cEKHxiF0XAigDdg';

const String urlTemplate = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapBoxAccessToken';

const String mapBoxStyleStreets = 'mapbox/streets-v12';
const String mapBoxStyleOutdoors = 'mapbox/outdoors-v12';
const String mapBoxStyleLight = 'mapbox/light-v11';
const String mapBoxStyleDark = 'mapbox/dark-v11';

const String urlSrc = 'sensorDataRe';

const double altaTemperatura = 30;
const double maxTempAmbiente = 26.9;

const Color altoColor = Color(0xFFFC5B4F);
const Color medioColor = Color(0xFFFFD24A);
const Color bajoColor = Color(0xFF41F388);

const Color altoStrokeColor = Color(0xFFB3342A);
const Color medioStrokeColor = Color(0xFFD89A1F);
const Color bajoStrokeColor = Color(0xFF1F9458);

const List<Color> myColorsListSoft = [
  Color(0xFFACB3FF),
  Color(0xFF6FD6CD),
  Color(0xFFF9DB81),
  Color(0xFFF6907A),
  Color(0xFFF7A2E3),
  Color(0xFF80E488),
  Color(0xFFD2CCED),
  Color(0xFF83ECE2),
  Color(0xFFA4EAB0),
  Color(0xFFF0A6BF),
  Color(0xFFC76A57),
  Color(0xFFD9B655),
];

const List<Color> myColorsListStrong = [
  Color(0xFF6C55B8),
  Color(0xFF26C9AF),
  Color(0xFFFC9B30),
  Color(0xFFE22E85),
  Color(0xFFD733DD),
  Color(0xFFA233DD),
  Color(0xFF465ADD),
  Color(0xFF3BAEE2),
];

Color getSoftColorbyIndex(int index) {
  late Color myColor;
  int myIndex = index % myColorsListSoft.length;

  for (var i = 0; i < myColorsListSoft.length; i++) {
    if (i == myIndex) {
      myColor = myColorsListSoft[i];
    }
  }

  return myColor;
}

Color getStrongColorbyIndex(int index) {
  late Color myColor;
  int myIndex = index % myColorsListStrong.length;

  for (var i = 0; i < myColorsListStrong.length; i++) {
    if (i == myIndex) {
      myColor = myColorsListStrong[i];
    }
  }

  return myColor;
}

const myPurple = Color(0xFF766ED1);
