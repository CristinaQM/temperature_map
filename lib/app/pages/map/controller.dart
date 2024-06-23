import 'package:get/get.dart';

class MapPageController extends GetxController {
  late MapEntry route;
  final List<dynamic> pointList = [];
  @override
  void onInit() {
    route = Get.arguments;
    pointList.addAll(route.value);
    super.onInit();
  }
}
