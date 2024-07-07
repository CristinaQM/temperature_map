import 'package:get/get.dart';

class DashboardPageController extends GetxController {
  late Map<String, dynamic> route;

  @override
  void onInit() {
    route = Get.arguments;
    super.onInit();
  }
}
