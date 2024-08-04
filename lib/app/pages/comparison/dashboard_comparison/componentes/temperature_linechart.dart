import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class MyLineChart extends StatelessWidget {
  final double maxWidth;
  const MyLineChart({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: lineTouchData,
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: bottomTitles(maxWidth),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: leftTitles(),
          ),
        ),
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 1,
        maxX: routesMaxId,
        maxY: routesMaxTemp,
        minY: routesMinTemp,
      ),
    );
  }

  double get routesMaxTemp {
    double maxTemp = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['temperatura'] > maxTemp) {
          maxTemp = point['temperatura'];
        }
      }
    }

    maxTemp = (maxTemp / 5).ceil().toDouble() * 5;

    return maxTemp;
  }

  double get routesMinTemp {
    double maxTemp = 100;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['temperatura'] < maxTemp) {
          maxTemp = point['temperatura'];
        }
      }
    }

    maxTemp = (maxTemp / 5).floor().toDouble() * 5;

    return maxTemp;
  }

  double get routesMaxId {
    double maxID = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['id'] > maxID) {
          maxID = point['id'];
        }
      }
    }

    return maxID;
  }

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => myPurple.withOpacity(0.8),
        ),
      );

  List<LineChartBarData> get lineBarsData {
    final List<LineChartBarData> lineBarList = [];
    final controller = Get.find<DashboardComparisonController>();
    for (var i = 0; i < controller.rutas.length; i++) {
      final lineChartBarData = LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: getSoftColorbyIndex(i),
        barWidth: 4,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: myFlSpotList(controller.rutas[i]),
      );
      lineBarList.add(lineChartBarData);
    }

    return lineBarList;
  }

  List<FlSpot> myFlSpotList(Map<String, dynamic> ruta) {
    final List<FlSpot> myList = [];

    for (var dataPoint in ruta['dataList']) {
      myList.add(FlSpot(dataPoint['id'], dataPoint['temperatura']));
    }

    return myList;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Text(
      (value.toInt() == 0) ? '' : '${value.toInt()}',
      style: style,
      textAlign: TextAlign.center,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 5,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final intValue = value.toInt();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: (intValue == 0)
          ? const SizedBox.shrink()
          : Text(
              '$intValue',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );
  }

  SideTitles bottomTitles(double maxWidth) => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: (maxWidth > 950) ? 1 : 5,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: myPurple.withOpacity(0.5), width: 4),
          left: BorderSide(color: myPurple.withOpacity(0.5), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );
}

class MyTemperatureLineChart extends StatefulWidget {
  final double maxWidth;
  const MyTemperatureLineChart({super.key, required this.maxWidth});

  @override
  State<StatefulWidget> createState() => MyTemperatureLineChartState();
}

class MyTemperatureLineChartState extends State<MyTemperatureLineChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 6),
            child: MyLineChart(
              maxWidth: widget.maxWidth,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
