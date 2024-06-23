class DataPoint {
  final int id;
  final double altitude;
  final double latitude;
  final double humidity;
  final double longitude;
  final double temperature;

  DataPoint({
    required this.id,
    required this.altitude,
    required this.latitude,
    required this.temperature,
    required this.humidity,
    required this.longitude,
  });

  DataPoint.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        altitude = json['altitude'],
        humidity = json['humedad'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        temperature = json['temperatura'];
}
