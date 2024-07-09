import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:temperature_map/app/pages/map/controller.dart';
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

    return FlutterMap(
      options: MapOptions(
        initialCenter: tappedPoints.first['latlng'],
        initialZoom: 22,
        maxZoom: 22,
        minZoom: 18,
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
              strokeWidth: 3,
            ),
          ],
        ),
        MarkerLayer(markers: markers),
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

    //TODO: Descomentar esto luego

    // final markerColor = (temp > 31)
    //     ? altoColor
    //     : (temp > 27)
    //         ? medioColor
    //         : bajoColor;

    final markerColor = (temp >= 32.6)
        ? altoColor
        : (temp > 32.4)
            ? medioColor
            : bajoColor;

    final borderColor = (temp >= 32.6)
        ? altoStrokeColor
        : (temp > 32.4)
            ? medioStrokeColor
            : bajoStrokeColor;

    return Obx(
      () => MouseRegion(
        cursor: SystemMouseCursors.click,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
