import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

import 'controller.dart';

class RutasDialog extends GetView<RutasController> {
  const RutasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RutasController());
    return AlertDialog(
      content: Obx(
        () => (controller.loading)
            ? const Center(
                child: SizedBox.square(
                  dimension: 48,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rutas Realizadas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Divider(),
                    Column(
                      children: controller.rutas.entries.map(
                        (r) {
                          return RouteWidget(
                            route: r,
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class RouteWidget extends StatelessWidget {
  final MapEntry route;
  const RouteWidget({
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> pointsList = route.value;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(
            Routes.map,
            arguments: route,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFCE7A2),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.key,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Punto Inicial'),
                  Text('Punto Final'),
                ],
              ),
              Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PolylineMarker(
                  initMap: pointsList.first,
                  finalMap: pointsList.last,
                  onTap: () {
                    Get.toNamed(
                      Routes.map,
                      arguments: route,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PolylineMarker extends StatefulWidget {
  final dynamic initMap;
  final dynamic finalMap;
  final void Function() onTap;

  const PolylineMarker({
    required this.initMap,
    required this.finalMap,
    required this.onTap,
    super.key,
  });

  @override
  State<PolylineMarker> createState() => _PolylineMarkerState();
}

class _PolylineMarkerState extends State<PolylineMarker> {
  @override
  Widget build(BuildContext context) {
    final initPoint = LatLng(
      widget.initMap['latitude'],
      widget.initMap['longitude'],
    );

    final finalPoint = LatLng(
      widget.finalMap['latitude'],
      widget.finalMap['longitude'],
    );

    final List<LatLng> tappedPoints = [initPoint, finalPoint];

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

    return FlutterMap(
      options: MapOptions(
        onTap: (p, l) {
          widget.onTap();
        },
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
        initialCenter: initPoint,
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
