import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class MapPageController extends GetxController {
  //Data
  late Map<String, dynamic> route;
  final List<dynamic> pointList = [];

  final database = FirebaseDatabase.instance;

  final urlSrc = 'sensorDataNuevoMariaIsabel';

  //Bools
  final _loading = true.obs;
  bool get loading => _loading.value;

  void fetchRoute() async {}

  @override
  void onInit() {
    print('PARAMETER: ${Get.parameters['dataKey']}');
    route = Get.arguments;
    pointList.addAll(route['dataList']);
    super.onInit();
  }
}
