import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/componentes/temperature_linechart.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';

class DashboardComparisonPage extends GetView<DashboardComparisonController> {
  const DashboardComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardComparisonController());
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(
            () {
              if (controller.loading) {
                return const Center(
                  child: SizedBox.square(
                    dimension: 48,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (controller.rutas.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: EmptyView(),
                );
              } else if (controller.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ErrorView(),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              final parameter = Get.parameters['dataKey']!;

                              String dataKey = parameter.substring(0, 10);
                              String strID = parameter.substring(10);

                              Get.offAndToNamed(
                                '/map_comparison/$dataKey$strID',
                              );
                            },
                            tooltip: "Retroceder",
                            icon: Icon(MdiIcons.arrowLeft),
                            iconSize: 50.0,
                          ),
                          IconButton(
                            onPressed: () {
                              controller.generateCSV();
                            },
                            tooltip: "Descargar Datos",
                            icon: Image.asset(
                              'images/excelicon.png',
                              fit: BoxFit.fill,
                              height: 60,
                              width: 60,
                            ),
                            iconSize: 60.0,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        height: 500,
                        width: double.infinity,
                        child: MyTemperatureLineChart(
                          maxWidth: constraints.maxWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
