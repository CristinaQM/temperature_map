import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class RutasController extends GetxController {
  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  bool multiSelect = false;
  RxList<Map<String, dynamic>> selectKeyList = <Map<String, dynamic>>[].obs;

  //Database
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
        list.removeWhere((item) => item['timestamp'] == null);
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

  ///Función para cambiar a vista ruta
  void goToMap({Map<String, dynamic>? route}) {
    //URL Parameter
    final parameter = Get.parameters['dataKey'];

    if (Get.currentRoute != '/home' && parameter != null) {
      //Nueva URL con todos los mapas seleccionados
      String newParam = '${parameter}_';
      final myLength = selectKeyList.length;

      for (var i = 0; i < myLength; i++) {
        final myRoute = selectKeyList[i];
        newParam += '${myRoute['dataKey']}${myRoute['id']}';

        if (i < myLength - 1) {
          newParam += '_';
        }
      }
      Get.offAndToNamed(
        '/map_comparison/$newParam',
      );
    } else {
      //Vista de una única ruta
      Get.offAndToNamed(
        '/map/${route!['dataKey']}${route['id']}',
      );
    }
  }

  ///Función llamada al hacer click sobre alguna ruta
  void onRouteTap(Map<String, dynamic> route) {
    //URL Parameter
    final parameter = Get.parameters['dataKey'];

    if (Get.currentRoute != '/home' && parameter != null) {
      final dataKey = route['dataKey'];

      if (selectKeyList
          .map(
            (myRoute) => myRoute['dataKey'],
          )
          .toList()
          .contains(dataKey)) {
        selectKeyList.removeWhere((myRoute) => myRoute['dataKey'] == dataKey);
      } else {
        selectKeyList.add(route);
      }
    } else {
      goToMap(route: route);
    }
  }
}
