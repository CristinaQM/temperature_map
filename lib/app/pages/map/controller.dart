import 'package:get/get.dart';

class MapPageController extends GetxController {
  late Map<String, dynamic> route;
  final List<dynamic> pointList = [];
  @override
  void onInit() {
    route = Get.arguments;
    pointList.addAll(route['dataList']);
    super.onInit();
  }
}
