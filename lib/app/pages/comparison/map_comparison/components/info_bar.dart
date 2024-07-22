import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/map_comparison/controller.dart';
import 'package:temperature_map/routes/pages.dart';

class MapComparisonBar extends StatelessWidget {
  const MapComparisonBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapComparisonController>();
    final rutasList = controller.rutas;

    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1.0, 0.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.offAllNamed(Routes.home);
                },
                icon: Icon(MdiIcons.arrowLeft),
              ),
              const Expanded(
                child: Text(
                  'Comparar Rutas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: controller.rutas.length,
              itemBuilder: (context, idx) {
                final ruta = controller.rutas[idx];

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Text(
                    'Ruta ${ruta['id']}',
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final myLength = rutasList.length;
              String newParam = '';
              for (var i = 0; i < myLength; i++) {
                final ruta = rutasList[i];
                newParam += '${ruta['dataKey']}${ruta['id']}';
                if (i < myLength - 1) {
                  newParam += '_';
                }
              }

              Get.offAndToNamed(
                '/dashboard_comparison/$newParam',
              );
            },
            child: const Text('Dashboard'),
          ),
        ],
      ),
    );
  }
}
