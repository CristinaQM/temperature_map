import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class MQ135LineChart extends StatelessWidget {
  final double maxWidth;
  const MQ135LineChart({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: lineTouchData,
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
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
        maxY: routesMaxMQ135,
        minY: routesMinMQ135,
      ),
    );
  }

  double get routesMaxMQ135 {
    double maxVal = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['MQ135'] != null && point['MQ135'] > maxVal) {
          maxVal = point['MQ135'];
        }
      }
    }

    maxVal = (maxVal / 100).ceil().toDouble() * 100;
    return maxVal;
  }

  double get routesMinMQ135 {
    double minVal = double.infinity;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['MQ135'] != null && point['MQ135'] < minVal) {
          minVal = point['MQ135'];
        }
      }
    }

    minVal = (minVal / 100).floor().toDouble() * 100;
    return minVal == double.infinity ? 0 : minVal;
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
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              return LineTooltipItem(
                '${touchedSpot.y.toStringAsFixed(2)} CO₂',
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
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
      if (dataPoint['MQ135'] != null) {
        myList.add(FlSpot(dataPoint['id'].toDouble(), dataPoint['MQ135']));
      }
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
        interval: 100,
        reservedSize: 40,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2)),
          left: BorderSide(color: Colors.black.withOpacity(0.2)),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}
