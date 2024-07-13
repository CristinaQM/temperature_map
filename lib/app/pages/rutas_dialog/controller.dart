import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RutasController extends GetxController {
  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  bool multiSelect = false;
  RxList<Map<String, dynamic>> selectKeyList = <Map<String, dynamic>>[].obs;

  //Database
  final urlSrc = 'sensorDataNuevoMariaIsabel';
  final database = FirebaseDatabase.instance;

  ///Obtener las rutas desde la base de datos en Firebase
  void fetchRecords() async {
    _loading.value = true;

    final parameter = Get.parameters['dataKey'];
    if (Get.currentRoute != '/home' && parameter != null) {
      multiSelect = true;
    }

    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();

    if (snapshot.exists) {
      _rutas.clear();
      final data = snapshot.value as Map;
      final map = data[urlSrc];

      int counter = 1;

      for (var ruta in map.entries) {
        final Map<String, dynamic> routeMap = {};

        routeMap['id'] = counter;
        routeMap['dataKey'] = ruta.key;

        //Points List
        final List<dynamic> list = ruta.value;
        list.removeWhere((item) => item == null);
        for (var i = 0; i < list.length; i++) {
          list[i].putIfAbsent('id', () => i);
        }
        routeMap['dataList'] = list;

        if (Get.currentRoute != '/home' && parameter != null) {
          final datakey = parameter.substring(0, 10);
          if (datakey != routeMap['dataKey']) {
            _rutas.add(routeMap);
          }
        } else {
          _rutas.add(routeMap);
        }

        counter++;
      }
    }

    _loading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    fetchRecords();
  }
}
