import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class RutasController extends GetxController {
  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas {
    _loading.value = true;

    if (textController.text.isNotEmpty) {
      //Lista de rutas filtradas
      List<Map<String, dynamic>> filterRoutes = [];

      //Fecha seleccionada
      String datePickedStr = textController.text;
      DateTime datePicked = DateTime.parse(datePickedStr);

      for (var ruta in _rutas) {
        final routeInitDate = ruta['dataList'].first['timestamp'];
        if (datePicked.isBefore(routeInitDate)) {
          filterRoutes.add(ruta);
        }
      }
      _loading.value = false;
      return filterRoutes;
    } else {
      _loading.value = false;
      return [..._rutas];
    }
  }

  //Multiselect
  bool multiSelect = false;
  RxList<Map<String, dynamic>> selectKeyList = <Map<String, dynamic>>[].obs;

  //Database
  final database = FirebaseDatabase.instance;

  //Filtro por fechas
  TextEditingController textController = TextEditingController();

  ///Abre un cuadro de diálogo con un calendario para elegir una fecha
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      errorFormatText: 'Formato Inválido',
      helpText: 'Fecha',
      confirmText: 'Confirmar',
      cancelText: 'Cancelar',
      fieldHintText: 'Fecha',
      fieldLabelText: 'Fecha (DD/MM/AAAA)',
    );

    if (picked != null) {
      textController.text = picked.toString().split(' ').first;
    }
  }

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

      for (var ruta in map.entries) {
        final Map<String, dynamic> routeMap = {};

        routeMap['dataKey'] = ruta.key;

        //Points List
        final List<dynamic> list = ruta.value;
        list.removeWhere((item) => item == null);
        list.removeWhere((item) => item['altitude'] == null);
        list.removeWhere((item) => item['latitude'] == null);
        list.removeWhere((item) => item['longitude'] == null);
        list.removeWhere((item) => item['humedad'] == null);
        list.removeWhere((item) => item['temperatura'] == null);
        list.removeWhere((item) => item['timestamp'] == null);
        for (var i = 0; i < list.length; i++) {
          list[i].putIfAbsent('id', () => i);
          final dateTime = DateTime.parse(list[i]['timestamp']);
          list[i]['timestamp'] = dateTime;
        }
        routeMap['dataList'] = list;

        _rutas.add(routeMap);
      }

      _rutas.sort((a, b) {
        final dta = a['dataList'].first['timestamp'];
        final dtb = b['dataList'].first['timestamp'];
        return (dta).compareTo(dtb);
      });

      for (var i = 0; i < _rutas.length; i++) {
        final ruta = _rutas[i];

        ruta['id'] = i + 1;
      }

      if (Get.currentRoute != '/home' && parameter != null) {
        final datakey = parameter.substring(0, 10);
        _rutas.removeWhere((ruta) => ruta['dataKey'] == datakey);
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
