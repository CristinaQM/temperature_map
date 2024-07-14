import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class MapComparisonController extends GetxController {
  //Obs
  final _loading = true.obs;
  final _rutas = <Map<String, dynamic>>[].obs;

  bool get loading => _loading.value;
  List<Map<String, dynamic>> get rutas => [..._rutas];

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  late String myParam;

  //Database
  final urlSrc = 'sensorDataNuevoMariaIsabel';
  final database = FirebaseDatabase.instance;

  void fetchRecords() async {
    _loading.value = true;

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

        for (var i = 0; i < pointsList.length; i++) {
          pointsList[i].putIfAbsent('id', () => i + 1);
        }

        routeMap['dataList'] = pointsList;

        _rutas.add(routeMap);
      }
    }

    _loading.value = false;
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
}
