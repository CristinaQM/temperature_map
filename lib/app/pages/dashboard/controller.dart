import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class DashboardPageController extends GetxController {
  //Data de la ruta seleccionada
  Map<String, dynamic> route = {};

  //Lista de los puntos de ubicación
  final pointList = <dynamic>[].obs;
  final mq135List = <dynamic>[].obs;
  final pm25List = <dynamic>[].obs;
  final pm10List = <dynamic>[].obs;

  final database = FirebaseDatabase.instance;

  final _loading = true.obs; //variable de carga
  bool get loading => _loading.value; //getter

  final _hasError = false.obs; //variable de error
  bool get hasError => _hasError.value; //getter

  //Función para llamar los datos de firebase y guardarlos
  Future<void> fetchRoute() async {
    _loading.value = true;

    try {
      final parameter = Get.parameters['dataKey']!;

      //Parameters
      String dataKey = parameter.substring(0, 10);
      String strID = parameter.substring(10);
      int id = int.parse(strID);

      //Guardamos la data en el Map de ruta
      route['id'] = id;
      route['dataKey'] = dataKey;

      final reference = FirebaseDatabase.instance.ref('$urlSrc/$dataKey');

      reference.onValue.listen(
        (DatabaseEvent event) async {
          final snapshot = event
              .snapshot.value; //obtenemos la data del firebase y la guardamos
          pointList
              .clear(); //limpiamos la lista para evitar colocar elementos repetidos
          mq135List.clear();
          pm25List.clear();
          pm10List.clear();

          pointList.addAll(snapshot as List<
              dynamic>); //agregamos toda la data (todos los json de los location points)
          pointList
              .removeWhere((item) => item == null); //borramos los datos nulos
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

  @override
  void onInit() async {
    await fetchRoute();
    super.onInit();
  }

  double getMaxValue(String parameter) {
    var list = parameter == 'MQ135'
        ? mq135List
        : parameter == 'PM2_5'
            ? pm25List
            : pm10List;

    if (list.isEmpty) return 0;

    double maxVal = 0;
    for (var point in list) {
      if (point[parameter] > maxVal) {
        maxVal = point[parameter].toDouble();
      }
    }
    return (maxVal / 5).ceil() * 5;
  }

  double getMinValue(String parameter) {
    var list = parameter == 'MQ135'
        ? mq135List
        : parameter == 'PM2_5'
            ? pm25List
            : pm10List;

    if (list.isEmpty) return 0;

    double minVal = double.infinity;
    for (var point in list) {
      if (point[parameter] < minVal) {
        minVal = point[parameter].toDouble();
      }
    }
    return (minVal / 5).floor() * 5;
  }

  void generateCSV() {
    final excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow([
      TextCellValue('Humedad'),
      TextCellValue('Temperatura'),
      TextCellValue('CO₂'),
      TextCellValue('PM₂.₅'),
      TextCellValue('PM₁₀'),
      TextCellValue('Latitude'),
      TextCellValue('Longitude'),
      TextCellValue('Altitude'),
    ]);

    for (var dataPoint in pointList) {
      sheet.appendRow([
        IntCellValue(dataPoint['humedad']),
        DoubleCellValue(dataPoint['temperatura']),
        dataPoint['MQ135'] != null
            ? DoubleCellValue(dataPoint['MQ135'])
            : TextCellValue(''),
        dataPoint['PM2_5'] != null
            ? DoubleCellValue(dataPoint['PM2_5'])
            : TextCellValue(''),
        dataPoint['PM10'] != null
            ? DoubleCellValue(dataPoint['PM10'])
            : TextCellValue(''),
        DoubleCellValue(dataPoint['latitude']),
        DoubleCellValue(dataPoint['longitude']),
        DoubleCellValue(dataPoint['altitude']),
      ]);
    }

    excel.save(fileName: 'dataProyectIotTelematic.xlsx');
  }
}
