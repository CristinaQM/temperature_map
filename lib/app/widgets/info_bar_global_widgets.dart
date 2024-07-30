import 'package:flutter/material.dart';

class PointParamTag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double? width;
  final String? boldLabel;
  const PointParamTag({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.width,
    this.boldLabel,
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
        SizedBox(width: width ?? 0),
        if (boldLabel != null)
          Text.rich(
            TextSpan(
              text: boldLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          )
        else
          Text(label),
      ],
    );
  }
}
