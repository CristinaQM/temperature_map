import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class MapComparisonPage extends GetView<MapComparisonController> {
  const MapComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MapComparisonController());
    return Scaffold(
      body: Column(
        children: [
          Text('Multi Map Page'),
          Text(controller.myParam),
        ],
      ),
    );
  }
}
