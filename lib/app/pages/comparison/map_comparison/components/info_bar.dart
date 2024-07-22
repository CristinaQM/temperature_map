import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/map_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';
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

                return RutaExpansionTile(ruta: ruta);
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

class RutaExpansionTile extends StatefulWidget {
  const RutaExpansionTile({
    super.key,
    required this.ruta,
  });

  final Map<String, dynamic> ruta;

  @override
  State<RutaExpansionTile> createState() => _RutaExpansionTileState();
}

class _RutaExpansionTileState extends State<RutaExpansionTile> {
  final controller = Get.find<MapComparisonController>();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          isExpanded = !isExpanded;
          setState(() {});
        },
        child: Column(
          children: [
            Obx(
              () => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: (controller.rutaActual['id'] == widget.ruta['id']) ? const Color(0xff766ED1) : const Color(0xFFD6EFEF),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ruta ${widget.ruta['id']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: (controller.rutaActual['id'] == widget.ruta['id']) ? Colors.white : Colors.black,
                      ),
                    ),
                    Icon((isExpanded) ? MdiIcons.chevronUp : MdiIcons.chevronDown),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              height: (isExpanded) ? 150 : 0,
              duration: const Duration(milliseconds: 500),
              child: (isExpanded)
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Hello World!'),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
