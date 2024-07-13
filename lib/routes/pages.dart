import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/view.dart';
import 'package:temperature_map/app/pages/comparison/map_comparison/view.dart';
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
    ),
    GetPage(
      name: '/map_comparison/:dataKey',
      page: () => const MapComparisonPage(),
    ),
    GetPage(
      name: '/dashboard_comparison/:dataKey',
      page: () => const DashboardComparisonPage(),
    ),
  ];
}
