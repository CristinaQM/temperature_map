import 'package:flutter/material.dart';
import 'package:temperature_map/core/app_constants.dart';

class TempColorInfoBox extends StatelessWidget {
  const TempColorInfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Índice',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          _TempLabel(
            label: 'T. Ambiente (≤ $maxTempAmbiente°C)',
            color: bajoColor,
          ),
          _TempLabel(
            label: 'T. Media ($maxTempAmbiente°C - $altaTemperatura°C)',
            color: medioColor,
          ),
          _TempLabel(
            label: 'T. Alta (> $altaTemperatura°C)',
            color: altoColor,
          ),
        ],
      ),
    );
  }
}

class _TempLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _TempLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 8,
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
