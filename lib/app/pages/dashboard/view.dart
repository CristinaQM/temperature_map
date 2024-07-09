import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/dashboard/components/bargraph.dart';

import 'package:temperature_map/app/pages/dashboard/components/linegraph.dart';
import 'package:temperature_map/app/pages/dashboard/components/scattergraph.dart';
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
                  Expanded(
                    child: Container(
                      height: 500.0,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const LineChartSample1()
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Container(
                      height: 500.0,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const ScatterChartSample2(),
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
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Dashboardgraphlinear(namegraphdash: "Temperatura"),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: Container(
                      height: 500.0,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Dashboardgraphlinear(namegraphdash: "Humedad"),
                    ),
                  ),
                    
                ],
              ),
            )
            
          ],
        ),
      )),
    );
  }
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
    return BarChartSample3(namegraph: widget.namegraphdash,tappedPoints: tappedPoint,);
  }
}