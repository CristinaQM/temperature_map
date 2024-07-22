import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  void initState() {
    controller.rutaActual = controller.rutas.first;
    super.initState();
  }

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
      mapController: controller.mapController,
      options: MapOptions(
        initialCenter: rutasList.first['dataList'].first['latlng'],
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
        Positioned(
          top: 30,
          right: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text.rich(
              TextSpan(
                text: 'Centro en Ruta ${controller.rutaActual!['id']}\n',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: '${controller.rutaActual!['dataList'].first['timestamp']}\n${controller.rutaActual!['dataList'].last['timestamp']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(
                Color(0xff766ED1),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              controller.newCenter();
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Siguiente',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Icon(
                    MdiIcons.arrowRightBoldCircle,
                    color: Colors.white,
                    size: 40,
                  )
                ],
              ),
            ),
          ),
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
