import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyPointDataColumn extends StatelessWidget {
  const MyPointDataColumn({
    super.key,
    required this.route,
    required this.pointsList,
    required this.color,
  });

  final Map<String, dynamic> route;
  final List pointsList;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PuntoTagWidget(
            label: 'Pt. Inicial',
            point: pointsList.first,
            color: color,
          ),
          const SizedBox(height: 10),
          PuntoTagWidget(
            label: 'Pt. Final',
            point: pointsList.last,
            color: color,
          ),
        ],
      ),
    );
  }
}

class PuntoTagWidget extends StatelessWidget {
  final String label;
  final dynamic point;
  final Color color;
  const PuntoTagWidget({
    required this.label,
    required this.point,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final datetime = point['timestamp'];
    final date = '${datetime.day}/${datetime.month}/${datetime.year}';
    final time = '${datetime.hour}:${datetime.minute}:${datetime.second.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Tooltip(
                message: 'Fecha',
                waitDuration: const Duration(milliseconds: 1000),
                child: Icon(MdiIcons.calendar, size: 20),
              ),
              const SizedBox(width: 10),
              Text(date),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Tooltip(
                message: 'Hora',
                waitDuration: const Duration(milliseconds: 1000),
                child: Icon(MdiIcons.clock, size: 20),
              ),
              const SizedBox(width: 10),
              Text(time),
            ],
          ),
          const SizedBox(height: 5),
          Tooltip(
            message: 'Latitud',
            waitDuration: const Duration(milliseconds: 1000),
            child: Row(
              children: [
                Icon(MdiIcons.latitude, size: 20),
                const SizedBox(width: 10),
                Text('${point['latitude']}'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Tooltip(
                message: 'Longitud',
                waitDuration: const Duration(milliseconds: 1000),
                child: Icon(MdiIcons.longitude, size: 20),
              ),
              const SizedBox(width: 10),
              Text('${point['longitude']}'),
            ],
          ),
        ],
      ),
    );
  }
}
