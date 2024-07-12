import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/dashboard/components/bargraph.dart';
import 'package:temperature_map/app/pages/dashboard/components/bargraphtemp.dart';

import 'package:temperature_map/app/pages/dashboard/components/linegraph.dart';
import 'package:temperature_map/app/pages/dashboard/components/scattergraph.dart';
import 'package:temperature_map/app/widgets/my_menubar.dart';
import 'controller.dart';

class DashboardPage extends GetView<DashboardPageController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Expanded(
        child: Obx(
          () {
            if (controller.loading) {
              return const Center(
                child: SizedBox.square(
                  dimension: 48,
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.pointList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                ),
              );
            } else if (controller.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                ),
              );
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          tooltip: "Retroceder",
                          icon: const Icon(Icons.keyboard_arrow_left_outlined),
                          iconSize: 50.0,
                        ),
                        IconButton(
                          onPressed: () {
                            //generateCSV();
                            final excel = Excel.createExcel();

                            // Crear una hoja en el libro
                            final sheet = excel['Sheet1'];

                            // Agregar encabezados
                            //sheet.appendRow([rowHeader[0],rowHeader[0] ]);

                            final controller =
                                Get.find<DashboardPageController>();
                            print(controller);
                            for (var dataPoint in controller.pointList) {
                              final pointAlt = dataPoint['altitud'];
                              final pointHum = dataPoint['humedad'];
                              final pointLat = dataPoint['latitude'];
                              final pointLong = dataPoint['longitud'];
                              final pointTem = dataPoint['temperatura'];
                              print(pointAlt);
                              sheet.appendRow([
                                IntCellValue(pointAlt),
                                IntCellValue(pointHum),
                                IntCellValue(pointLat),
                                IntCellValue(pointLong),
                                IntCellValue(pointTem)
                              ]);
                              // sheet.appendRow(pointHum);
                              // sheet.appendRow(pointLat);
                              // sheet.appendRow(pointLong);
                              // sheet.appendRow(pointTem);
                              // sheet.appendRow(datacsv);
                            }
                            excel.save(fileName: 'excel.xlsx');
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: 500.0,
                                decoration: const BoxDecoration(
                                    color: Colors.lightBlueAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: const Dashboardtemphum()),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: 500.0,
                              decoration: const BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: const ScatterChartSample2(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 500.0,
                              decoration: const BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: const DashboardgraphlinearTemp(
                                  namegraphdash: "Temperatura (C°)"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: 500.0,
                              decoration: const BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: const Dashboardgraphlinear(
                                  namegraphdash: "Humedad (%)"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void generateCSV() {
  // final List<String> rowHeader = [
  //   "altitud",
  //   "humedad",
  //   "latitude",
  //   "longitud",
  //   "temperatura"
  // ];
  // Crear un nuevo libro Excel
  final excel = Excel.createExcel();

  // Crear una hoja en el libro
  final sheet = excel['Sheet1'];

  // Agregar encabezados
  //sheet.appendRow([rowHeader[0],rowHeader[0] ]);

  final controller = Get.find<DashboardPageController>();
  print(controller);
  for (var dataPoint in controller.pointList) {
    final pointAlt = dataPoint['altitud'];
    final pointHum = dataPoint['humedad'];
    final pointLat = dataPoint['latitude'];
    final pointLong = dataPoint['longitud'];
    final pointTem = dataPoint['temperatura'];
    print(pointAlt);
    sheet.appendRow([
      IntCellValue(pointAlt),
      IntCellValue(pointHum),
      IntCellValue(pointLat),
      IntCellValue(pointLong),
      IntCellValue(pointTem)
    ]);
    // sheet.appendRow(pointHum);
    // sheet.appendRow(pointLat);
    // sheet.appendRow(pointLong);
    // sheet.appendRow(pointTem);
    // sheet.appendRow(datacsv);
  }
  excel.save(fileName: 'excel.xlsx');
}

class Dashboardgraphlinear extends StatefulWidget {
  final String namegraphdash;
  const Dashboardgraphlinear({super.key, required this.namegraphdash});

  @override
  State<Dashboardgraphlinear> createState() => _DashboardgraphlinearState();
}

class _DashboardgraphlinearState extends State<Dashboardgraphlinear> {
  final controller = Get.find<DashboardPageController>();

  @override
  Widget build(BuildContext context) {
    final List<double> tappedPoint = [];

    for (var dataPoint in controller.pointList) {
      final point = dataPoint['humedad'];
      tappedPoint.add(point);
    }

    return BarChartSample3(
      namegraph: widget.namegraphdash,
      tappedPoints: tappedPoint,
    );
  }
}

class DashboardgraphlinearTemp extends StatefulWidget {
  final String namegraphdash;
  const DashboardgraphlinearTemp({super.key, required this.namegraphdash});

  @override
  State<DashboardgraphlinearTemp> createState() =>
      _DashboardgraphlinearTempState();
}

class _DashboardgraphlinearTempState extends State<DashboardgraphlinearTemp> {
  final controller = Get.find<DashboardPageController>();

  @override
  Widget build(BuildContext context) {
    final List<double> tempPoint = [];

    for (var dataPoint in controller.pointList) {
      final point = dataPoint['temperatura'];
      tempPoint.add(point);
    }

    return BarChartSample3Temp(
      namegraph: widget.namegraphdash,
      tappedPoints: tempPoint,
    );
  }
}

class Dashboardtemphum extends StatefulWidget {
  const Dashboardtemphum({super.key});

  @override
  State<Dashboardtemphum> createState() => _DashboardtemphumState();
}

class _DashboardtemphumState extends State<Dashboardtemphum> {
  final controller = Get.find<DashboardPageController>();
  @override
  Widget build(BuildContext context) {
    final List<double> tempPoint = [];

    for (var dataPoint in controller.pointList) {
      final point = dataPoint['temperatura'];
      tempPoint.add(point);
    }

    final List<double> tappedPoint = [];

    for (var dataPoint in controller.pointList) {
      final point = dataPoint['humedad'];
      tappedPoint.add(point);
    }

    return LineChartSample1(
      humepoint: tappedPoint,
      temppoint: tempPoint,
    );
  }
}
