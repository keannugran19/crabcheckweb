import 'package:crabcheckweb1/pages/dashboard/pieChart/badge.dart';
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
    return Column(
      children: [
        topBarTitle(),
        const SizedBox(height: 20),
        // Pie Chart
        pieChart(),
        // const SizedBox(height: 20),
        // Legends
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Indicator(
        //       color: const Color(0xFFFF9800),
        //       text: 'C. Carnifex',
        //       isSquare: false,
        //       size: touchedIndex == 0 ? 18 : 16,
        //     ),
        //     Indicator(
        //       color: const Color(0xFF795548),
        //       text: 'S. Serrata',
        //       isSquare: false,
        //       size: touchedIndex == 1 ? 18 : 16,
        //     ),
        //     Indicator(
        //       color: const Color(0xFFFDD835),
        //       text: 'V. Latreillei',
        //       isSquare: false,
        //       size: touchedIndex == 2 ? 18 : 16,
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Indicator(
        //       color: const Color(0xFF2196F3),
        //       text: 'P. Pelagicus',
        //       isSquare: false,
        //       size: touchedIndex == 3 ? 18 : 16,
        //     ),
        //     Indicator(
        //       color: const Color(0xFF9C27B0),
        //       text: 'M. Spp',
        //       isSquare: false,
        //       size: touchedIndex == 4 ? 18 : 16,
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget pieChart() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: PieChart(
          PieChartData(
            pieTouchData: pieTouchData(),
            borderData: FlBorderData(show: false),
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: showingSections(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 150),
          swapAnimationCurve: Curves.easeInOut,
        ),
      ),
    );
  }

  Widget topBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pie_chart, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          'Crab Species Distribution',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  PieTouchData pieTouchData() {
    return PieTouchData(
      touchCallback: (FlTouchEvent event, pieTouchResponse) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              pieTouchResponse == null ||
              pieTouchResponse.touchedSection == null) {
            touchedIndex = -1;
            return;
          }
          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
        });
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0; // Increased font sizes
      final radius = isTouched ? 115.0 : 110.0;
      final shadows = [
        Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)
      ];
      switch (i) {
        case 0:
          return PieChartSectionData(
            badgeWidget: const PieBadge(
                imgAsset: 'lib/assets/images/crabs/cardisomaCarnifex.jpg'),
            badgePositionPercentageOffset: 1,
            color: const Color(0xFFFF9800),
            value: widget.cardisomaCarnifexCount.toDouble(),
            title:
                '${((widget.cardisomaCarnifexCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
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
            badgeWidget: const PieBadge(
                imgAsset: 'lib/assets/images/crabs/scyllaSerrata.jpg'),
            badgePositionPercentageOffset: 1,
            color: const Color(0xFF795548),
            value: widget.scyllaSerrataCount.toDouble(),
            title:
                '${((widget.scyllaSerrataCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
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
            badgeWidget: const PieBadge(
                imgAsset: 'lib/assets/images/crabs/venitusLatreillei.jpeg'),
            badgePositionPercentageOffset: 1,
            color: const Color(0xFFFDD835),
            value: widget.venitusLatreilleiCount.toDouble(),
            title:
                '${((widget.venitusLatreilleiCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
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
            badgeWidget: const PieBadge(
                imgAsset: 'lib/assets/images/crabs/portunosPelagicus.jpg'),
            badgePositionPercentageOffset: 1,
            color: const Color(0xFF2196F3),
            value: widget.portunosPelagicusCount.toDouble(),
            title:
                '${((widget.portunosPelagicusCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
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
            badgeWidget: const PieBadge(
                imgAsset: 'lib/assets/images/crabs/metopograpsusSp.jpeg'),
            badgePositionPercentageOffset: 1,
            color: const Color(0xFF9C27B0),
            value: widget.metopograpsusSppCount.toDouble(),
            title:
                '${((widget.metopograpsusSppCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
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

  int getTotalCount() {
    return widget.cardisomaCarnifexCount +
        widget.scyllaSerrataCount +
        widget.venitusLatreilleiCount +
        widget.portunosPelagicusCount +
        widget.metopograpsusSppCount;
  }
}
