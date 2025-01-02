import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class PM25LineChart extends StatelessWidget {
  final double maxWidth;
  const PM25LineChart({super.key, required this.maxWidth});

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
        maxY: routesMaxPM25,
        minY: routesMinPM25,
      ),
    );
  }

  double get routesMaxPM25 {
    double maxVal = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM2_5'] != null && point['PM2_5'] > maxVal) {
          maxVal = point['PM2_5'];
        }
      }
    }

    maxVal = (maxVal / 5).ceil().toDouble() * 5;
    return maxVal;
  }

  double get routesMinPM25 {
    double minVal = double.infinity;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM2_5'] != null && point['PM2_5'] < minVal) {
          minVal = point['PM2_5'];
        }
      }
    }

    minVal = (minVal / 5).floor().toDouble() * 5;
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
                '${touchedSpot.y.toStringAsFixed(2)} PM₂.₅',
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
      if (dataPoint['PM2_5'] != null) {
        myList.add(FlSpot(dataPoint['id'].toDouble(), dataPoint['PM2_5']));
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
        interval: 5,
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
