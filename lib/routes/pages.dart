import 'package:get/get.dart';
import 'package:temperature_map/app/pages/home/view.dart';
part './routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
  ];
}
