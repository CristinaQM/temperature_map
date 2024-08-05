import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class DashboardPageController extends GetxController {
  //Data de la ruta seleccionada
  Map<String, dynamic> route = {};

  //Lista de los puntos de ubicación
  final pointList = <dynamic>[].obs;

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
          final snapshot = event.snapshot.value; //obtenemos la data del firebase y la guardamos
          pointList.clear(); //limpiamos la lista para evitar colocar elementos repetidos

          pointList.addAll(snapshot as List<dynamic>); //agregamos toda la data (todos los json de los location points)
          pointList.removeWhere((item) => item == null); //borramos los datos nulos
          pointList.removeWhere((item) => item['altitude'] == null);
          pointList.removeWhere((item) => item['latitude'] == null);
          pointList.removeWhere((item) => item['longitude'] == null);
          pointList.removeWhere((item) => item['humedad'] == null);
          pointList.removeWhere((item) => item['temperatura'] == null);
          pointList.removeWhere((item) => item['timestamp'] == null);

          for (var i = 0; i < pointList.length; i++) {
            pointList[i].putIfAbsent('id', () => i + 1);
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

  void generateCSV() {
    final excel = Excel.createExcel();

    Sheet sheet = excel['Sheet1'];
    CellStyle cellStyle = CellStyle(fontFamily: getFontFamily(FontFamily.Al_Nile));
    cellStyle.underline = Underline.Single;
    sheet.appendRow(
      [
        const TextCellValue('Humedad'),
        const TextCellValue('Temperatura'),
        const TextCellValue('Latitude'),
        const TextCellValue('Longitude'),
        const TextCellValue('Altitude'),
      ],
    );

    final controller = Get.find<DashboardPageController>();
    for (var dataPoint in controller.pointList) {
      final point = dataPoint['humedad'];
      final temp = dataPoint['temperatura'];
      final lat = dataPoint['latitude'];
      final long = dataPoint['longitude'];
      final alt = dataPoint['altitude'];
      sheet.appendRow(
        [
          IntCellValue(point),
          DoubleCellValue(temp),
          DoubleCellValue(lat),
          DoubleCellValue(long),
          DoubleCellValue(alt),
        ],
      );
    }
    excel.save(fileName: 'dataProyectIotTelematic.xlsx');
  }
}
