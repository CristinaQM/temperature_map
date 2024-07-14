import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/map/controller.dart';
import 'package:temperature_map/app/pages/rutas_dialog/view.dart';
import 'package:temperature_map/app/widgets/info_bar_global_widgets.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'package:temperature_map/routes/pages.dart';

class MapComparisonBar extends StatelessWidget {
  const MapComparisonBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();
    final route = controller.route;

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
              Expanded(
                child: Text(
                  'Ruta ${route['id']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: controller.pointList.length,
              itemBuilder: (context, idx) {
                final point = controller.pointList[idx];
                final temp = point['temperatura'];

                final color = (temp >= altaTemperatura)
                    ? altoColor
                    : (temp > maxTempAmbiente)
                        ? medioColor
                        : bajoColor;

                return DataPointTile(
                  point: point,
                  color: color,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.dialog(const RutasDialog());
            },
            child: const Text('Comparar Rutas'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(
                '/dashboard/${route['dataKey']}${route['id']}',
              );
            },
            child: const Text('Dashboard'),
          ),
        ],
      ),
    );
  }
}

class DataPointTile extends StatelessWidget {
  final dynamic point;
  const DataPointTile({
    super.key,
    required this.point,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MapPageController>();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (controller.selectedPointID == point['id']) {
            controller.selectedPointID = 0;
          } else {
            controller.selectedPointID = point['id'];
          }
        },
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Color(
                (controller.selectedPointID == point['id']) ? 0xff766ED1 : 0xFFD6EFEF,
              ).withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 15,
                  child: Text(
                    '${point['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                PointParamTag(
                  label: '${point['temperatura']}°C',
                  icon: MdiIcons.thermometer,
                  color: const Color(0xFFFF9F31),
                ),
                const SizedBox(width: 40),
                PointParamTag(
                  label: '${point['humedad']}',
                  icon: MdiIcons.waterPercent,
                  color: const Color(0xFF3180FF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
