import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/componentes/temperature_linechart.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: controller.rutas
                              .asMap()
                              .entries
                              .map<Widget>(
                                (ruta) => RouteLineCard(
                                  index: ruta.key,
                                  ruta: ruta.value,
                                ),
                              )
                              .toList(),
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

class RouteLineCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> ruta;
  const RouteLineCard({
    super.key,
    required this.index,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> dataList = [...ruta['dataList']];
    dataList.sort(
      (a, b) {
        final ta = a['temperatura'];
        final tb = b['temperatura'];

        return ta.compareTo(tb);
      },
    );
    final maxTemp = dataList.last;
    final minTemp = dataList.first;

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: myPurple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ruta ${ruta['id']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: getColorbyIndex(index),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          Text.rich(
            TextSpan(
              text: 'T. Max: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '${maxTemp['temperatura']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              text: 'T. Min: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '${minTemp['temperatura']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
