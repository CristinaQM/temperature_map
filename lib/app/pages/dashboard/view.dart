import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/dashboard/components/linegraph.dart';
import 'controller.dart';

class DashboardPage extends GetView<DashboardPageController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardPageController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Expanded(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
                  onPressed: () {},
                  tooltip: "Descargar Datos",
                  icon: const Icon(Icons.download_sharp),
                  iconSize: 50.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 500.0,
                    width: 500.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const LineChartSample1()
                    ),
                  )
                  
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
