import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/rutas_dialog/components/point_data_column.dart';

import 'components/map_polyline.dart';
import 'controller.dart';

class RutasDialog extends GetView<RutasController> {
  const RutasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RutasController());
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => AlertDialog(
        content: SizedBox(
          height: 550,
          child: Obx(
            () => (controller.loading)
                ? const Center(
                    child: SizedBox.square(
                      dimension: 48,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Rutas Realizadas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: controller.rutas.map(
                              (r) {
                                return RouteWidget(
                                  maxWidth: constraints.maxWidth,
                                  route: r,
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      if (controller.multiSelect)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Cancelar'),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => ElevatedButton(
                                  onPressed: (controller.selectKeyList.isEmpty)
                                      ? null
                                      : () {
                                          //MultiSelect MapView
                                          controller.goToMap();
                                        },
                                  child: const Text('Confirmar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class RouteWidget extends StatelessWidget {
  final Map<String, dynamic> route;
  final double maxWidth;
  const RouteWidget({
    required this.route,
    required this.maxWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> pointsList = route['dataList'];
    final controller = Get.find<RutasController>();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          controller.onRouteTap(route);
        },
        child: Obx(
          () {
            bool isSelected = controller.selectKeyList
                .map(
                  (myRoute) => myRoute['dataKey'],
                )
                .contains(route['dataKey']);
            int defaultColor = 0xFFFCE7A2;
            int selectedColor = 0xff766ED1;

            int secondDefaultColor = 0xffEBC285;
            int secondSelectedColor = 0xFF4E46A3;

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Color(
                  (isSelected) ? selectedColor : defaultColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Text(
                    'Ruta ${route['id']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: Color((isSelected) ? secondSelectedColor : secondDefaultColor).withOpacity(0.75),
                  ),
                  if (maxWidth > 650)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyPointDataColumn(
                          route: route,
                          pointsList: pointsList,
                          color: Color(
                            (isSelected) ? secondSelectedColor : secondDefaultColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        MapContainer(
                          pointsList: pointsList,
                          controller: controller,
                          route: route,
                        ),
                      ],
                    )
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyPointDataColumn(
                          route: route,
                          pointsList: pointsList,
                          color: Color((controller.selectKeyList
                                  .map(
                                    (myRoute) => myRoute['dataKey'],
                                  )
                                  .contains(route['dataKey']))
                              ? secondSelectedColor
                              : secondDefaultColor),
                        ),
                        const SizedBox(height: 10),
                        MapContainer(
                          pointsList: pointsList,
                          controller: controller,
                          route: route,
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
