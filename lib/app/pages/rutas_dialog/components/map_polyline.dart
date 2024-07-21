import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/rutas_dialog/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class MapContainer extends StatelessWidget {
  const MapContainer({
    super.key,
    required this.pointsList,
    required this.controller,
    required this.route,
  });

  final List pointsList;
  final RutasController controller;
  final Map<String, dynamic> route;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
