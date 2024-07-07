import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class DashboardPage extends GetView<DashboardPageController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardPageController());
    return Scaffold(
      body: Center(
        child: Text('Ruta: ${controller.route['id']}'),
      ),
    );
  }
}
