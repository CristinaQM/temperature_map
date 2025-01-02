import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temperature_map/app/pages/dashboard/controller.dart';
import 'package:temperature_map/core/app_constants.dart';

class _CO2LineChart extends StatelessWidget {
  const _CO2LineChart();

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
        maxY: routesMaxCO2,
        minY: routesMinCO2,
      );

  double get routesMaxCO2 {
    final controller = Get.find<DashboardPageController>();
    return controller.getMaxValue('MQ135');
  }

  double get routesMinCO2 {
    final controller = Get.find<DashboardPageController>();
    return controller.getMinValue('MQ135');
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
        lineChartBarDataCO2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(value.toString(), style: style),
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 50,
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

  LineChartBarData get lineChartBarDataCO2 {
    List<FlSpot> spots = [];
    final controller = Get.find<DashboardPageController>();

    for (var point in controller.mq135List) {
      spots.add(FlSpot(point['id'].toDouble(), point['MQ135'].toDouble()));
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

class CO2LineChart extends StatefulWidget {
  const CO2LineChart({super.key});

  @override
  State<StatefulWidget> createState() => CO2LineChartState();
}

class CO2LineChartState extends State<CO2LineChart> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 37),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 30, left: 10),
            child: _CO2LineChart(),
          ),
        ),
      ],
    );
  }
}
