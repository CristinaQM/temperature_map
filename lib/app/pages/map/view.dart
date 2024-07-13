import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';

import 'components/info_bar.dart';
import 'components/location_points.dart';
import 'controller.dart';

class MapPage extends GetView<MapPageController> {
  const MapPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MapPageController());
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
          } else if (controller.pointList.isEmpty) {
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
          return const Stack(
            children: [
              MapPagePolyline(),
              MapViewBar(),
            ],
          );
        },
      ),
    );
  }
}
