import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
                ? const SizedBox(
                    width: 400,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 48,
                        child: CircularProgressIndicator(),
                      ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DateFieldPicker(
                                controller: controller,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                controller.rutas;
                              },
                              icon: Icon(MdiIcons.magnify),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (controller.rutas.isEmpty)
                                ? [
                                    const SizedBox(height: 40),
                                    Icon(
                                      MdiIcons.mapMarkerRemove,
                                      size: 150,
                                      color: const Color(0xFF7179DB),
                                    ),
                                    const SizedBox(height: 40),
                                    Container(
                                      width: 480,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 10,
                                      ),
                                      child: const Text(
                                        'No se encontraron rutas realizadas después de la fecha seleccionada. Por favor, elija una fecha diferente.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ]
                                : controller.rutas.map(
                                    (r) {
                                      return RouteWidget(
                                        key: UniqueKey(),
                                        maxWidth: constraints.maxWidth,
                                        route: r,
                                      );
                                    },
                                  ).toList(),
                          ),
                        ),
                      ),
                      //Botones de selección si es multi selección
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

class DateFieldPicker extends StatelessWidget {
  const DateFieldPicker({
    super.key,
    required this.controller,
  });

  final RutasController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.textController,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 50),
        labelText: 'Fecha Inicio',
        filled: true,
        prefixIcon: const Icon(Icons.calendar_today),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF7179DB),
          ),
        ),
        suffix: IconButton(
          onPressed: () {
            controller.textController.clear();
            controller.rutas;
          },
          icon: Icon(MdiIcons.closeCircle),
        ),
      ),
      readOnly: true,
      onTap: () {
        controller.selectDate(context);
      },
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
