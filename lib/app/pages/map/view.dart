import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

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
      body: Stack(
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
                  'Map View \n${controller.route.key}',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.dashboard,
                      arguments: route,
                    );
                  },
                  child: Text('Dashboard'),
                ),
              ],
            ),
          ),
        ],
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
