import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/comparison/dashboard_comparison/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class PM10LineChart extends StatelessWidget {
  final double maxWidth;
  const PM10LineChart({super.key, required this.maxWidth});

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
        maxY: routesMaxPM10,
        minY: routesMinPM10,
      ),
    );
  }

  double get routesMaxPM10 {
    double maxPM10 = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM10'] != null && point['PM10'] > maxPM10) {
          maxPM10 = point['PM10'].toDouble();
        }
      }
    }

    maxPM10 = (maxPM10 / 5).ceil().toDouble() * 5;
    return maxPM10;
  }

  double get routesMinPM10 {
    double minPM10 = double.infinity;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['PM10'] != null && point['PM10'] < minPM10) {
          minPM10 = point['PM10'].toDouble();
        }
      }
    }

    minPM10 = (minPM10 / 5).floor().toDouble() * 5;
    return minPM10;
  }

  double get routesMaxId {
    double maxID = 0;
    final controller = Get.find<DashboardComparisonController>();

    for (var ruta in controller.rutas) {
      for (var point in ruta['dataList']) {
        if (point['id'] > maxID) {
          maxID = point['id'].toDouble();
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
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors.first ??
                    touchedSpot.bar.color ??
                    Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                '${touchedSpot.y.toStringAsFixed(2)} µg/m³',
                textStyle,
              );
            }).toList();
          },
          getTooltipColor: (touchedSpot) => myPurple.withOpacity(0.8),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 2),
          left: BorderSide(color: Colors.black.withOpacity(0.2), width: 2),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 5,
        reservedSize: 42,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return Text(
      '${value.toInt()} µg/m³',
      style: style,
      textAlign: TextAlign.center,
    );
  }

  List<LineChartBarData> get lineBarsData {
    final List<LineChartBarData> lineBarList = [];
    final controller = Get.find<DashboardComparisonController>();

    for (var i = 0; i < controller.rutas.length; i++) {
      final spots = <FlSpot>[];

      for (var point in controller.rutas[i]['dataList']) {
        if (point['PM10'] != null) {
          spots.add(FlSpot(
            point['id'].toDouble(),
            point['PM10'].toDouble(),
          ));
        }
      }

      if (spots.isNotEmpty) {
        final lineChartBarData = LineChartBarData(
          isCurved: true,
          curveSmoothness: 0,
          color: getSoftColorbyIndex(i),
          barWidth: 4,
          dotData: const FlDotData(show: false),
          spots: spots,
        );
        lineBarList.add(lineChartBarData);
      }
    }

    return lineBarList;
  }
}
