import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class DashboardComparisonController extends GetxController {
  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  late String myParam;

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

  bool hasMQ135Data() {
    for (var ruta in rutas) {
      for (var point in ruta['dataList']) {
        if (point['MQ135'] != null) return true;
      }
    }
    return false;
  }

  bool hasPM25Data() {
    for (var ruta in rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM2_5'] != null) return true;
      }
    }
    return false;
  }

  bool hasPM10Data() {
    for (var ruta in rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM10'] != null) return true;
      }
    }
    return false;
  }

  void generateCSV() {
    final excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // Headers
    List<String> headers = [
      'humedad',
      'temperatura',
      'latitude',
      'longitude',
      'altitude'
    ];

    if (hasMQ135Data()) headers.add('MQ135');
    if (hasPM25Data()) headers.add('PM2_5');
    if (hasPM10Data()) headers.add('PM10');

    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    for (var ruta in rutas) {
      sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
      for (var dataPoint in ruta['dataList']) {
        List<CellValue> row = [
          IntCellValue(dataPoint['humedad']),
          DoubleCellValue(dataPoint['temperatura']),
          DoubleCellValue(dataPoint['latitude']),
          DoubleCellValue(dataPoint['longitude']),
          DoubleCellValue(dataPoint['altitude'])
        ];

        if (hasMQ135Data()) {
          row.add(dataPoint['MQ135'] != null
              ? DoubleCellValue(dataPoint['MQ135'])
              : TextCellValue(''));
        }
        if (hasPM25Data()) {
          row.add(dataPoint['PM2_5'] != null
              ? DoubleCellValue(dataPoint['PM2_5'])
              : TextCellValue(''));
        }
        if (hasPM10Data()) {
          row.add(dataPoint['PM10'] != null
              ? DoubleCellValue(dataPoint['PM10'])
              : TextCellValue(''));
        }

        sheet.appendRow(row);
      }
    }
    excel.save(fileName: 'dataProyectIotTelematicRutas.xlsx');
  }
}
