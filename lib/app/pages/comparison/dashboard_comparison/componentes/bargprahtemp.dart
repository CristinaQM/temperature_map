import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class _BarChart extends StatefulWidget {
  final List<Map<String, dynamic>> tappedPoints;

  const _BarChart({required this.tappedPoints});

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> {
  
  @override
  Widget build(BuildContext context) {
    List maxejey = [];
    for (var item in widget.tappedPoints) {
      maxejey.add(double.parse(item["temp"]));
    }
    double maxNumero = maxejey.reduce((a, b) => a > b ? a : b);
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxNumero,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.indigoAccent,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    int index = value.toInt();
    if (index >= 0 && index < widget.tappedPoints.length) {
      var item = widget.tappedPoints[index];
      String text = "Ruta ";
      String label = text + item["rutaid"].toString();
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: Text(label, style: style),
      );
    } else {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 4,
        child: const Text('', style: style),
      );
    }

  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.cyan,
          Colors.deepPurpleAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> barData = [];
    int i = 0;
    for (var item in widget.tappedPoints) {
      barData.add(
        BarChartGroupData(x: i++, 
          barRods: [
            BarChartRodData(
              toY: double.parse(item["temp"]),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        )
      );
    }
    return barData;
  }
}

class BarChartSample3Temp extends StatefulWidget {
  final String namegraph;
  final List<Map<String, dynamic>> tappedPoints;
  const BarChartSample3Temp(
      {super.key, required this.namegraph, required this.tappedPoints});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3Temp> {
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
              Text(
                widget.namegraph,
                style: const TextStyle(
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
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _BarChart(tappedPoints: widget.tappedPoints),
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
