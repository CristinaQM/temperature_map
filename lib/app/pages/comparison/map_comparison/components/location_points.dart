import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:temperature_map/app/pages/comparison/map_comparison/controller.dart';

import 'package:temperature_map/core/app_constants.dart';

class MapComparisonPolyline extends StatefulWidget {
  const MapComparisonPolyline({
    super.key,
  });

  @override
  State<MapComparisonPolyline> createState() => _MapComparisonPolylineState();
}

class _MapComparisonPolylineState extends State<MapComparisonPolyline> {
  final controller = Get.find<MapComparisonController>();
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rutasList = controller.rutas;

    for (var ruta in rutasList) {
      for (var dataPoint in ruta['dataList']) {
        final point = LatLng(dataPoint['latitude'], dataPoint['longitude']);
        dataPoint['latlng'] = point;
      }
    }

    final List<Widget> markersLayers = rutasList.map<Widget>(
      (ruta) {
        final List<dynamic> tappedPoints = ruta['dataList'];
        return MarkerLayer(
          markers: tappedPoints
              .map<Marker>(
                (dataPoint) => Marker(
                  point: dataPoint['latlng'],
                  child: _DataPointWidget(dataPoint: dataPoint),
                ),
              )
              .toList(),
        );
      },
    ).toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: rutasList.first['dataList'].first['latlng'],
        initialZoom: 22,
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
          polylines: rutasList.map<Polyline<Object>>(
            (ruta) {
              final List<dynamic> tappedPoints = ruta['dataList'];
              return Polyline(
                points: tappedPoints.map<LatLng>(
                  (p) {
                    return p['latlng'];
                  },
                ).toList(),
                color: Colors.black,
                strokeWidth: 10,
              );
            },
          ).toList(),
        ),
        ...markersLayers,
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

    return Container(
      decoration: BoxDecoration(
        color: markerColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: borderColor,
          width: 2,
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
    );
  }
}
