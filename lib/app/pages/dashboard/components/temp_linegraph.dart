import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/dashboard/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 1,
        maxX: routesMaxId,
        maxY: routesMaxTemp,
        minY: routesMinTemp,
      );

  double get routesMaxTemp {
    double maxTemp = 0;
    final controller = Get.find<DashboardPageController>();

    for (var point in controller.pointList) {
      if (point['temperatura'] > maxTemp) {
        maxTemp = point['temperatura'];
      }
    }

    maxTemp = (maxTemp / 5).ceil().toDouble() * 5;

    return maxTemp;
  }

  double get routesMinTemp {
    double maxTemp = 100;
    final controller = Get.find<DashboardPageController>();

    for (var point in controller.pointList) {
      if (point['temperatura'] < maxTemp) {
        maxTemp = point['temperatura'];
      }
    }

    maxTemp = (maxTemp / 5).floor().toDouble() * 5;

    return maxTemp;
  }

  double get routesMaxId {
    double maxID = 0;
    final controller = Get.find<DashboardPageController>();

    for (var point in controller.pointList) {
      if (point['id'] > maxID) {
        maxID = point['id'];
      }
    }

    return maxID;
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        // bottomTitles: AxisTitles(
        //   sideTitles: bottomTitles,
        // ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        lineChartBarDataTemp,
      ];

  //LEFT TITLES

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = " ";

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text + value.toString(), style: style),
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 5,
        reservedSize: 40,
      );

  //BOTTOM TITLES

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = " ";

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text + value.toString(), style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: myPurple.withOpacity(0.5), width: 4),
          left: BorderSide(color: myPurple.withOpacity(0.5), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarDataTemp {
    List<FlSpot> spots = [];
    final controller = Get.find<DashboardPageController>();

    for (int i = 0; i < controller.pointList.length; i++) {
      final point = controller.pointList[i];
      double temp = point['temperatura'];

      spots.add(FlSpot(point['id'], temp));
    }

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      color: const Color(0xFFF9DB81),
      curveSmoothness: 0,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );

    return lineChartBarData;
  }
}

class TempLineChart extends StatefulWidget {
  const TempLineChart({super.key});

  @override
  State<StatefulWidget> createState() => TempLineChartState();
}

class TempLineChartState extends State<TempLineChart> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 37,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30, left: 10),
            child: _LineChart(),
          ),
        ),
      ],
    );
  }
}
