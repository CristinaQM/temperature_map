import 'package:get/get.dart';

class DashboardPageController extends GetxController {
  late MapEntry route;

  @override
  void onInit() {
    route = Get.arguments;
    super.onInit();
  }
}
