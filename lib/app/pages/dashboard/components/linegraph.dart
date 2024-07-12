import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  final List<double> humepoint;
  final List<double> temppoint;
  const _LineChart(
      {required this.isShowingMainData,
      required this.humepoint,
      required this.temppoint});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        //temperatura
        minX: 20,
        maxX: 40,
        maxY: 80,
        minY: 40,
        //humedad
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
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
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
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
  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '1m';
  //       break;
  //     case 2:
  //       text = '2m';
  //       break;
  //     case 3:
  //       text = '3m';
  //       break;
  //     case 4:
  //       text = '5m';
  //       break;
  //     case 5:
  //       text = '6m';
  //       break;
  //     default:
  //       return Container();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.center);
  // }


  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 5,
        reservedSize: 40,
      );

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
  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 16,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 2:
  //       text = const Text('SEPT', style: style);
  //       break;
  //     case 7:
  //       text = const Text('OCT', style: style);
  //       break;
  //     case 12:
  //       text = const Text('DEC', style: style);
  //       break;
  //     default:
  //       text = const Text('');
  //       break;
  //   }
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 10,
  //     child: text,
  //   );
  // }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 2,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          // bottom:
          //  BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );


  LineChartBarData get lineChartBarData1_1 {
    List<FlSpot> spots = [];

    for (int i = 0; i < humepoint.length; i++) {
      double hume = humepoint[i];
      double temp = temppoint[i]; 

      spots.add(FlSpot(temp, hume));
    }

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      color: Colors.amber, 
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );

    return lineChartBarData;
  }
}

class LineChartSample1 extends StatefulWidget {
  final List<double> humepoint;
  final List<double> temppoint;
  const LineChartSample1(
      {super.key, required this.humepoint, required this.temppoint});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Temperatura vs Humedad',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 10),
                  child: _LineChart(
                    isShowingMainData: isShowingMainData,
                    humepoint: widget.humepoint,
                    temppoint: widget.temppoint,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
