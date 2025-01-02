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
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 1,
        maxX: routesMaxId,
        maxY: routesMaxPM10,
        minY: routesMinPM10,
      );

  double get routesMaxPM10 {
    final controller = Get.find<DashboardPageController>();
    return controller.getMaxValue('PM10');
  }

  double get routesMinPM10 {
    final controller = Get.find<DashboardPageController>();
    return controller.getMinValue('PM10');
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

  FlTitlesData get titlesData => FlTitlesData(
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
        lineChartBarDataPM10,
      ];

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

  LineChartBarData get lineChartBarDataPM10 {
    List<FlSpot> spots = [];
    final controller = Get.find<DashboardPageController>();

    for (var point in controller.pm10List) {
      spots.add(FlSpot(point['id'].toDouble(), point['PM10'].toDouble()));
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: const Color(0xFF6FD6CD),
      curveSmoothness: 0,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class PM10LineChart extends StatefulWidget {
  const PM10LineChart({super.key});

  @override
  State<StatefulWidget> createState() => PM10LineChartState();
}

class PM10LineChartState extends State<PM10LineChart> {
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
