import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:temperature_map/core/app_constants.dart';

class MapPageController extends GetxController {
  //Data
  Map<String, dynamic> route = {};

  //Location Points
  final pointList = <dynamic>[].obs;

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

          pointList.addAll(snapshot as List<dynamic>);
          pointList.removeWhere((item) => item == null);

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
}
