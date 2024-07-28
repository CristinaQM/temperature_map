import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/componentes/bargprahtemp.dart';
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
  final controller = Get.find<DashboardComparisonController>();
  for (var ruta in controller.rutas) {
    sheet.appendRow([const TextCellValue('humedad'),const TextCellValue('temperatura'),const TextCellValue('latitude'),const TextCellValue('longitude'),const TextCellValue('altitude')]);
    for (var dataPoint in ruta['dataList']){
      print(dataPoint);
      sheet.appendRow([IntCellValue(dataPoint['humedad']),DoubleCellValue(dataPoint['temperatura']), DoubleCellValue(dataPoint['latitude']), DoubleCellValue(dataPoint['longitude']), DoubleCellValue(dataPoint['altitude'])]);
    }
  }
  excel.save(fileName: 'dataProyectIotTelematicRutas.xlsx');
}

class TempHumeGraph extends StatelessWidget {
  final controller = Get.find<DashboardComparisonController>();
  TempHumeGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rutasList = controller.rutas;
    final List<Map<String, dynamic>> rutas = [];
    
    String rutid = "rutaid";
    String temp = "temp";
    for (var ruta in rutasList) {
      final List<dynamic> templist = [];
      for (var dataPoint in ruta['dataList']) {
        templist.add(dataPoint["temperatura"]);
      }
      if(templist.length>=4){
        List valore = [];
        for( var i = 0; i<= 4; i++){  
          valore.add(templist[i]);
        }
        var suma = valore.reduce((a, b) => a + b);
        rutas.add({rutid: ruta["id"],temp: suma.toStringAsFixed(1)});
      }
      else {
        List valore = [];
        for( var i = 0; i<= templist.length; i++){  
          valore.add(templist[i]);
        }
        var suma = valore.reduce((a, b) => a + b);
        rutas.add({rutid: ruta["id"],temp: suma.toStringAsFixed(1)});

      }
    }
    return BarChartSample3Temp(namegraph: "Temperatura Promedio",tappedPoints: rutas,);
  }
}