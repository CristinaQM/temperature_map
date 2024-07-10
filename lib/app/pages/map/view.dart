import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/widgets/my_menubar.dart';

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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const MyMenuBar(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.giftOpen,
                          size: 120,
                          color: const Color(0xff30A0A4),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'No existe información para mostrar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (controller.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const MyMenuBar(),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.alertCircle,
                          size: 120,
                          color: const Color(0xffE96544),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Ocurrió un Error al cargar la Información',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
