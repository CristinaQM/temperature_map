import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class MapComparisonController extends GetxController {
  late String myParam;

  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  RxMap<String, dynamic> selectedPoint = <String, dynamic>{}.obs;

  //Map
  RxMap<String, dynamic> rutaActual = <String, dynamic>{}.obs;

  MapController mapController = MapController();

  void newCenter({Map<String, dynamic>? miRuta, Map<String, dynamic>? miPoint, bool? move = false}) {
    if (miRuta == null) {
      final currentPointID = rutaActual['id'];
      final currentPointIdx = rutas.indexOf(
        rutas.firstWhere(
          (ruta) => ruta['id'] == currentPointID,
        ),
      );

      int listLength = rutas.length;
      int newPointIdx = currentPointIdx + 1;

      if (newPointIdx > listLength - 1) {
        newPointIdx = 0;
      }
      selectedPoint.clear();

      rutaActual.value = rutas[newPointIdx];

      mapController.move(
        rutaActual['dataList'].first['latlng'],
        18,
      );
    } else {
      rutaActual.value = miRuta;
      if (move != null && move) {
        mapController.move(
          miPoint!['latlng'],
          20,
        );
      }
    }
  }

  //Database
  final database = FirebaseDatabase.instance;

  void fetchRecords() async {
    _loading.value = true;

    try {
      _rutas.clear();

      final parameter = Get.parameters['dataKey'];
      final paramList = parameter!.split('_').toList();

      for (var param in paramList) {
        final Map<String, dynamic> routeMap = {};
        final List<dynamic> pointsList = [];

        //Parameters
        String dataKey = param.substring(0, 10);
        String strID = param.substring(10);
        int id = int.parse(strID);

        //Firebase Data
        final ref = FirebaseDatabase.instance.ref('$urlSrc/$dataKey');
        final snapshot = await ref.get();

        if (snapshot.exists) {
          routeMap['id'] = id;
          routeMap['dataKey'] = dataKey;

          final data = snapshot.value;
          pointsList.addAll(data as List<dynamic>);
          pointsList.removeWhere((item) => item == null);
          pointsList.removeWhere((item) => item['altitude'] == null);
          pointsList.removeWhere((item) => item['latitude'] == null);
          pointsList.removeWhere((item) => item['longitude'] == null);
          pointsList.removeWhere((item) => item['humedad'] == null);
          pointsList.removeWhere((item) => item['temperatura'] == null);
          pointsList.removeWhere((item) => item['timestamp'] == null);

          for (var i = 0; i < pointsList.length; i++) {
            pointsList[i].putIfAbsent('id', () => i + 1);
          }

          routeMap['dataList'] = pointsList;

          _rutas.add(routeMap);
        }
      }

      _rutas.sort((a, b) => (a['id']).compareTo(b['id']));

      _loading.value = false;
    } catch (e) {
      _loading.value = false;
      _hasError.value = true;
    }
  }

  @override
  void onInit() {
    myParam = Get.parameters['dataKey']!;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    fetchRecords();
  }

  // void newCenter(int pointID) {
  //   for (var point in pointList) {
  //     if (point['id'] == pointID) {
  //       mapController.move(
  //         point['latlng'],
  //         20,
  //       );
  //     }
  //   }
  // }
}
