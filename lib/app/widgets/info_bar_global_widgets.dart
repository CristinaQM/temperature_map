import 'package:flutter/material.dart';

class PointParamTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const PointParamTag({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(label),
      ],
    );
  }
}
