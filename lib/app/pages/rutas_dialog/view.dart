import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/core/app_constants.dart';

import 'controller.dart';

class RutasDialog extends GetView<RutasController> {
  const RutasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RutasController());
    return AlertDialog(
      content: SizedBox(
        height: 550,
        child: Obx(
          () => (controller.loading)
              ? const Center(
                  child: SizedBox.square(
                    dimension: 48,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.rutas.map(
                            (r) {
                              return RouteWidget(
                                route: r,
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    if (controller.multiSelect)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            Obx(
                              () => ElevatedButton(
                                onPressed: (controller.selectKeyList.isEmpty)
                                    ? null
                                    : () {
                                        //MultiSelect MapView
                                        controller.goToMap();
                                      },
                                child: const Text('Confirmar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class RouteWidget extends StatelessWidget {
  final Map<String, dynamic> route;
  const RouteWidget({
    required this.route,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> pointsList = route['dataList'];
    final controller = Get.find<RutasController>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          controller.onRouteTap(route);
        },
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Color(
                (controller.selectKeyList
                        .map(
                          (myRoute) => myRoute['dataKey'],
                        )
                        .contains(route['dataKey']))
                    ? 0xff766ED1
                    : 0xFFFCE7A2,
              ),
              borderRadius: const BorderRadius.all(
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
                      'Ruta ${route['id']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Punto Inicial'),
                    const Text('Punto Final'),
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
                      controller.onRouteTap(route);
                    },
                  ),
                ),
              ],
            ),
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
          urlTemplate: urlTemplate,
          fallbackUrl: urlTemplate,
          additionalOptions: const {
            'id': mapBoxStyleOutdoors,
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
