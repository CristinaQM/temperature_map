import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/dashboard/components/hum_linegraph.dart';
import 'package:temperature_map/app/pages/dashboard/components/temp_linegraph.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';
import 'package:temperature_map/core/app_constants.dart';
import 'controller.dart';

class DashboardPage extends GetView<DashboardPageController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardPageController());
    return Scaffold(
      body: Obx(
        () {
          if (controller.loading) {
            return const Center(
              child: SizedBox.square(
                dimension: 48,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (controller.pointList.isEmpty) {
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
                            '/map/$dataKey$strID',
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
                  const Text(
                    'Temperatura (°C) vs Recorrido',
                    style: TextStyle(
                      color: myPurple,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: myPurple.withOpacity(0.5),
                            offset: const Offset(1.0, 0.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 500,
                            width: 1400,
                            child: TempLineChart(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Puntos Censados',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Divider(
                      color: myPurple.withOpacity(0.5),
                      thickness: 5,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Humedad (%) vs Recorrido',
                    style: TextStyle(
                      color: myPurple,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: myPurple.withOpacity(0.5),
                            offset: const Offset(1.0, 0.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 500,
                            width: 1400,
                            child: HumLineChart(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Puntos Censados',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
