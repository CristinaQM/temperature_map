import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';

import 'controller.dart';

class DashboardComparisonPage extends GetView<DashboardComparisonController> {
  const DashboardComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardComparisonController());
    return Scaffold(
      body: Obx(
        () {
          if (controller.loading) {
            return const Center(
              child: SizedBox.square(
                dimension: 48,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (controller.rutas.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: EmptyView(),
            );
          } else if (controller.hasError) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: ErrorView(),
            );
          }
          return Text(controller.myParam);
        },
      ),
    );
  }
}
