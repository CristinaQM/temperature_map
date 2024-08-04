import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
                      const Text(
                        'Comparativa de Temperaturas por Ruta',
                        style: TextStyle(
                          color: myPurple,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Container(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 500,
                              width: 1400,
                              child: MyTemperatureLineChart(
                                maxWidth: constraints.maxWidth,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Puntos Censados',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
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
                      const SizedBox(height: 30),
                      Divider(
                        color: myPurple.withOpacity(0.5),
                        thickness: 5,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Temperatura Promedio por Ruta',
                        style: TextStyle(
                          color: myPurple,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      RoutesTempAvg(controller: controller),
                      const SizedBox(height: 30),
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

class RoutesTempAvg extends StatelessWidget {
  const RoutesTempAvg({
    super.key,
    required this.controller,
  });

  final DashboardComparisonController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: controller.rutas
          .asMap()
          .entries
          .map<Widget>(
            (ruta) => _RouteTempCircle(
              ruta: ruta.value,
              index: ruta.key,
            ),
          )
          .toList(),
    );
  }
}

class _RouteTempCircle extends StatelessWidget {
  final int index;
  final Map<String, dynamic> ruta;
  const _RouteTempCircle({
    required this.ruta,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double tempPromedio = 0;
    final List<dynamic> myList = ruta['dataList'];
    int myLength = myList.length;

    for (var myPoint in myList) {
      tempPromedio += myPoint['temperatura'];
    }

    tempPromedio = tempPromedio / myLength;

    return Column(
      children: [
        Container(
          width: 150,
          margin: const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.all(8),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ruta ${ruta['id']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: getSoftColorbyIndex(index),
                    radius: 12,
                  ),
                ],
              ),
              Divider(
                color: myPurple.withOpacity(0.5),
              ),
              CircularPercentIndicator(
                radius: 60,
                animation: true,
                lineWidth: 10,
                percent: tempPromedio / 100,
                center: Text(
                  '${tempPromedio.toStringAsFixed(2)} °C',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: (tempPromedio >= altaTemperatura)
                    ? altoColor
                    : (tempPromedio > maxTempAmbiente)
                        ? medioColor
                        : bajoColor,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ],
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
                  color: getSoftColorbyIndex(index),
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
                  text: '${maxTemp['temperatura']}°C',
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
                  text: '${minTemp['temperatura']}°C',
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
