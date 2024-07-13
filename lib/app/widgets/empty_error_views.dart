import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'my_menubar.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MyMenuBar(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.giftOpen,
                size: 120,
                color: const Color(0xff30A0A4),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'No existe información para mostrar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MyMenuBar(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.alertCircle,
                size: 120,
                color: const Color(0xffE96544),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Ocurrió un Error al cargar la Información',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
