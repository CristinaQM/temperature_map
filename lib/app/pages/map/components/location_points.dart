import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:temperature_map/app/pages/map/controller.dart';
import 'package:temperature_map/app/widgets/temp_color_info.dart';
import 'package:temperature_map/core/app_constants.dart';

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
    final List<dynamic> tappedPoints = controller.pointList;

    for (var i = 0; i < tappedPoints.length; i++) {
      final dataPoint = tappedPoints[i];
      final point = LatLng(dataPoint['latitude'], dataPoint['longitude']);
      dataPoint['latlng'] = point;
    }

    final markers = tappedPoints
        .map(
          (dataPoint) => Marker(
            point: dataPoint['latlng'],
            child: _DataPointWidget(
              dataPoint: dataPoint,
            ),
          ),
        )
        .toList();

    return Stack(
      children: [
        FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: tappedPoints.first['latlng'],
            initialZoom: 18,
            maxZoom: 22,
          ),
          children: [
            TileLayer(
              urlTemplate: urlTemplate,
              fallbackUrl: urlTemplate,
              additionalOptions: const {
                'id': mapBoxStyleOutdoors,
              },
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: tappedPoints
                      .map<LatLng>(
                        (e) => e['latlng'],
                      )
                      .toList(),
                  color: Colors.black,
                  strokeWidth: 10,
                ),
              ],
            ),
            MarkerLayer(markers: markers),
          ],
        ),
        const Positioned(
          top: 30,
          right: 30,
          child: TempColorInfoBox(),
        ),
      ],
    );
  }
}

class _DataPointWidget extends StatelessWidget {
  final dynamic dataPoint;
  const _DataPointWidget({
    required this.dataPoint,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();

    final id = dataPoint['id'];
    final temp = dataPoint['temperatura'];

    final markerColor = (temp >= altaTemperatura)
        ? altoColor
        : (temp > maxTempAmbiente)
            ? medioColor
            : bajoColor;

    final borderColor = (temp >= altaTemperatura)
        ? altoStrokeColor
        : (temp > maxTempAmbiente)
            ? medioStrokeColor
            : bajoStrokeColor;

    return Obx(
      () => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Tooltip(
          waitDuration: const Duration(milliseconds: 500),
          message: '$temp°C',
          decoration: BoxDecoration(
            color: myPurple.withOpacity(0.8),
            borderRadius: BorderRadius.circular(5),
          ),
          child: GestureDetector(
            onTap: () {
              if (controller.selectedPointID == dataPoint['id']) {
                controller.selectedPointID = 0;
              } else {
                controller.selectedPointID = dataPoint['id'];
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: markerColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: (controller.selectedPointID == id) ? const Color(0xff766ED1) : borderColor,
                  width: (controller.selectedPointID == id) ? 4 : 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$id',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: (id.toString().length < 3) ? 15 : 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
