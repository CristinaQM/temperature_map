import 'package:get/get.dart';
import 'package:temperature_map/app/pages/dashboard/view.dart';
import 'package:temperature_map/app/pages/home/view.dart';
import 'package:temperature_map/app/pages/map/view.dart';
part './routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: '/map/:dataKey',
      page: () => const MapPage(),
    ),
    GetPage(
      name: '/dashboard/:dataKey',
      page: () => const DashboardPage(),
    )
  ];
}
