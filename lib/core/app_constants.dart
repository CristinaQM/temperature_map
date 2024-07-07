class AppConstants {
  static const String mapBoxAccessToken = 'pk.eyJ1IjoiY2VxdWludGUiLCJhIjoiY2xuZ3hoZnMxMGllcjJrbzJkaWoxbXg3aCJ9.Fwsq4U7cEKHxiF0XAigDdg';

  static const String urlTemplate = 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapBoxAccessToken';

  static const String mapBoxStyleStreets = 'mapbox/streets-v12';
  static const String mapBoxStyleOutdoors = 'mapbox/outdoors-v12';
  static const String mapBoxStyleLight = 'mapbox/light-v11';
  static const String mapBoxStyleDark = 'mapbox/dark-v11';
}
