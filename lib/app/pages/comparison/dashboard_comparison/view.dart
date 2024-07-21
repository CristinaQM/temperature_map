import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/data/models/datapoint.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/componentes/temprutas.dart';
import 'package:temperature_map/app/widgets/empty_error_views.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';


class DashboardComparisonPage extends GetView<DashboardComparisonController> {
  const DashboardComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardComparisonController());
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
                              '/map/$dataKey$strID',
                            );
                          },
                          tooltip: "Retroceder",
                          icon: Icon(MdiIcons.arrowLeft),
                          iconSize: 50.0,
                        ),
                        IconButton(
                          onPressed: () {
                            generateCSV();
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: 500.0,
                                decoration: const BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: const Text("c")),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: 500.0,
                              decoration: const BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: TempHumeGraph(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 500.0,
                              decoration: const BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              child: const Text("c"),
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
    );
  }
}

void generateCSV() {
  final excel = Excel.createExcel();

  Sheet sheet = excel['Sheet1'];
  CellStyle cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Al_Nile));
  cellStyle.underline = Underline.Single;
  sheet.appendRow([const TextCellValue('humedad'),const TextCellValue('temperatura'),const TextCellValue('latitude'),const TextCellValue('longitude'),const TextCellValue('altitude')]);

  final controller = Get.find<DashboardComparisonController>();
  for (var dataPoint in controller.rutas) {
      //final point = dataPoint['humedad'];
      //final temp = dataPoint['temperatura'];
      //final lat = dataPoint['latitude'];
      //final long = dataPoint['longitude'];
      //final alt = dataPoint['altitude'];
      //sheet.appendRow([IntCellValue(point),DoubleCellValue(temp), DoubleCellValue(lat), DoubleCellValue(long), DoubleCellValue(alt)]);
  }
  excel.save(fileName: 'dataProyectIotTelematic.xlsx');
}

class TempHumeGraph extends StatelessWidget {
  final controller = Get.find<DashboardComparisonController>();
  TempHumeGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rutasList = controller.rutas;
    final List<Map<String, dynamic>> rutas = [];
    final List<dynamic> templist = [];
    String rutid = "rutaid";
    String temp = "temp";
    for (var ruta in rutasList) {
      //print(ruta);
      rutas.add({rutid: ruta["id"],temp: templist});
      for (var dataPoint in ruta['dataList']) {
        templist.add(dataPoint["temperatura"]);
        print(dataPoint);
        print(dataPoint["temperatura"]);
      }
      // for (int i = 0 ; i < dataPoint["temperatura"].len; i++){
      print(ruta);
      // }
      //rutas.add({rutid: ruta["id"],temp: templist});
    }
    print(rutas);
    return BarChartSample2(rutastemp: rutas,);
  }
}
// class _DashboardtemphumState extends State<Dashboardtemphum> {
//   final controller = Get.find<DashboardPageController>();
//   @override
//   Widget build(BuildContext context) {
//     final List<double> tempPoint = [];

//     for (var dataPoint in controller.pointList) {
//       final point = dataPoint['temperatura'];
//       tempPoint.add(point);
//     }

//     final List<double> tappedPoint = [];

//     for (var dataPoint in controller.pointList) {
//       final point = dataPoint['humedad'];
//       tappedPoint.add(point);
//     }

//     return LineChartSample1(
//       humepoint: tappedPoint,
//       temppoint: tempPoint,
//     );
//   }
// }
