import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class MapPageController extends GetxController {
  //Data
  Map<String, dynamic> route = {};

  MapController mapController = MapController();

  //Location Points
  final pointList = <dynamic>[].obs;
  final mq135List = <dynamic>[].obs;
  final pm25List = <dynamic>[].obs;
  final pm10List = <dynamic>[].obs;

  final _selectedPointID = 0.obs;

  int get selectedPointID => _selectedPointID.value;

  set selectedPointID(int id) {
    _selectedPointID.value = id;
  }

  final database = FirebaseDatabase.instance;
  late DatabaseReference reference;

  //Bools
  final _loading = true.obs;
  bool get loading => _loading.value;

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  Future<void> fetchRoute() async {
    _loading.value = true;

    try {
      final parameter = Get.parameters['dataKey']!;

      //Parameters
      String dataKey = parameter.substring(0, 10);
      String strID = parameter.substring(10);
      int id = int.parse(strID);

      //Map Values
      route['id'] = id;
      route['dataKey'] = dataKey;

      //Firebase Data
      reference = FirebaseDatabase.instance.ref('$urlSrc/$dataKey');
      reference.onValue.listen(
        (DatabaseEvent event) async {
          final snapshot = event.snapshot.value;
          pointList.clear();
          mq135List.clear();
          pm25List.clear();
          pm10List.clear();

          pointList.addAll(snapshot as List<dynamic>);
          pointList.removeWhere((item) => item == null);
          pointList.removeWhere((item) => item['altitude'] == null);
          pointList.removeWhere((item) => item['latitude'] == null);
          pointList.removeWhere((item) => item['longitude'] == null);
          pointList.removeWhere((item) => item['humedad'] == null);
          pointList.removeWhere((item) => item['temperatura'] == null);
          pointList.removeWhere((item) => item['timestamp'] == null);

          for (var i = 0; i < pointList.length; i++) {
            pointList[i].putIfAbsent('id', () => i + 1);
            if (pointList[i]['MQ135'] != null) {
              mq135List.add(pointList[i]);
            }
            if (pointList[i]['PM2_5'] != null) {
              pm25List.add(pointList[i]);
            }
            if (pointList[i]['PM10'] != null) {
              pm10List.add(pointList[i]);
            }
          }

          _loading.value = false;
        },
      );
    } catch (e) {
      _loading.value = false;
      _hasError.value = true;
    }
  }

  double calculateAverage(String parameter) {
    double sum = 0;
    int count = 0;

    for (var point in pointList) {
      if (point[parameter] != null) {
        sum += point[parameter];
        count++;
      }
    }

    return count > 0 ? sum / count : 0;
  }

  double normalizeValue(double value, String key) {
    switch (key) {
      case 'MQ135':
        return value > 1000 ? 100 : value / 10;
      default:
        return value;
    }
  }

  void newCenter(int pointID) {
    for (var point in pointList) {
      if (point['id'] == pointID) {
        mapController.move(
          point['latlng'],
          20,
        );
      }
    }
  }

  @override
  void onInit() async {
    await fetchRoute();
    super.onInit();
  }
}
