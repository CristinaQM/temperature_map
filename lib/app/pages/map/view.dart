import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/widgets/my_menubar.dart';
import 'package:temperature_map/core/app_constants.dart';

import 'controller.dart';

class MapPage extends GetView<MapPageController> {
  const MapPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(MapPageController());
    final route = controller.route;
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
          return Stack(
            children: [
              const MapPagePolyline(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 0.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Map View \nRuta${route['id']}',
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          '/dashboard/${route['id']}${route['dataKey']}',
                        );
                      },
                      child: const Text('Dashboard'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MapPagePolyline extends StatefulWidget {
  const MapPagePolyline({
    super.key,
  });

  @override
  State<MapPagePolyline> createState() => _MapPagePolylineState();
}

class _MapPagePolylineState extends State<MapPagePolyline> {
  final controller = Get.find<MapPageController>();
  @override
  Widget build(BuildContext context) {
    final List<LatLng> tappedPoints = [];

    for (var dataPoint in controller.pointList) {
      final point = LatLng(dataPoint['latitude'], dataPoint['longitude']);
      tappedPoints.add(point);
    }

    final markers = tappedPoints
        .map(
          (latlng) => Marker(
            point: latlng,
            child: Icon(
              MdiIcons.mapMarker,
              color: Colors.red,
              size: 60,
            ),
          ),
        )
        .toList();
    // return Text('ABC');
    return FlutterMap(
      options: MapOptions(
        initialCenter: tappedPoints.first,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: AppConstants.urlTemplate,
          fallbackUrl: AppConstants.urlTemplate,
          additionalOptions: const {
            'id': AppConstants.mapBoxStyleOutdoors,
          },
        ),
        MarkerLayer(markers: markers),
        PolylineLayer(
          polylines: [
            Polyline(
              points: tappedPoints,
              color: Colors.red,
              strokeWidth: 5,
            ),
          ],
        ),
      ],
    );
  }
}
