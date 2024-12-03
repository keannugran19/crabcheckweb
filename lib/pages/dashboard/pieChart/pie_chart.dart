import 'package:crabcheckweb1/pages/dashboard/pieChart/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartDisplay extends StatefulWidget {
  final int cardisomaCarnifexCount;
  final int scyllaSerrataCount;
  final int venitusLatreilleiCount;
  final int portunosPelagicusCount;
  final int metopograpsusSppCount;

  const PieChartDisplay({
    super.key,
    required this.cardisomaCarnifexCount,
    required this.scyllaSerrataCount,
    required this.venitusLatreilleiCount,
    required this.portunosPelagicusCount,
    required this.metopograpsusSppCount,
  });

  @override
  State<PieChartDisplay> createState() => _PieChartDisplayState();
}

class _PieChartDisplayState extends State<PieChartDisplay> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 80,
              sections: showingSections(),
            ),
          ),
        ),
        const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Indicator(
              color: Colors.orange,
              text: 'Cardisoma Carnifex',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.brown,
              text: 'Scylla Serrata',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.yellow,
              text: 'Venitus Latreillei',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.blue,
              text: 'Portunos Pelagicus',
              isSquare: true,
            ),
            SizedBox(
              height: 4,
            ),
            Indicator(
              color: Colors.purple,
              text: 'Metopograpsus Spp',
              isSquare: true,
            ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 40.0 : 32.0;
      final radius = isTouched ? 100.0 : 90.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.orange,
            value: widget.cardisomaCarnifexCount.toDouble(),
            title: widget.cardisomaCarnifexCount.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.brown,
            value: widget.scyllaSerrataCount.toDouble(),
            title: widget.scyllaSerrataCount.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.yellow,
            value: widget.venitusLatreilleiCount.toDouble(),
            title: widget.venitusLatreilleiCount.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.portunosPelagicusCount.toDouble(),
            title: widget.portunosPelagicusCount.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purple,
            value: widget.metopograpsusSppCount.toDouble(),
            title: widget.metopograpsusSppCount.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
