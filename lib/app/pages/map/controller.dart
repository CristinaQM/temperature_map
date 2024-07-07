import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class MapPageController extends GetxController {
  //Data
  Map<String, dynamic> route = {};

  //Location Points
  final pointList = <dynamic>[].obs;

  final database = FirebaseDatabase.instance;

  final urlSrc = 'sensorDataNuevoMariaIsabel';

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
      String dataKey = parameter.substring(1);
      int id = int.parse(parameter.substring(0, 1));

      //Map Values
      route['id'] = id;
      route['dataKey'] = dataKey;

      //Firebase Data
      final reference = FirebaseDatabase.instance.ref('$urlSrc/$dataKey');
      reference.onValue.listen(
        (DatabaseEvent event) async {
          final snapshot = event.snapshot.value;
          pointList.clear();

          pointList.addAll(snapshot as List<dynamic>);
          pointList.removeWhere((item) => item == null);

          for (var i = 0; i < pointList.length; i++) {
            pointList[i].putIfAbsent('id', () => i);
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
}
