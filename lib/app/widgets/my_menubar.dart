import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/rutas_dialog/view.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _TitleBarButton(
            label: 'Ver Mapas',
            onTap: () {
              //'Ver Mapas función';
              Get.dialog(const RutasDialog());
            },
          ),
          const SizedBox(
            width: 20,
          ),
          _TitleBarButton(
            label: 'Redes',
            onTap: () {
              // print('Ver Redes Función');
            },
          ),
        ],
      ),
    );
  }
}

class _TitleBarButton extends StatelessWidget {
  final String label;
  final void Function() onTap;
  const _TitleBarButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 219, 205, 205).withOpacity(0.4),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
