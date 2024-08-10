import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/rutas_dialog/view.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      decoration: (Get.currentRoute != Routes.home)
          ? const BoxDecoration(
              color: myPurple,
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _TitleBarButton(
            label: (Get.currentRoute != Routes.home) ? 'Home' : 'Ver Mapas',
            onTap: () {
              //'Ver Mapas función';
              if (Get.currentRoute != Routes.home) {
                Get.offAllNamed(Routes.home);
              } else {
                Get.dialog(const RutasDialog());
              }
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
