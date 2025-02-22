import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/badge.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    // total count of crabs for error handling
    int totalCount = widget.cardisomaCarnifexCount +
        widget.scyllaSerrataCount +
        widget.venitusLatreilleiCount +
        widget.portunosPelagicusCount +
        widget.metopograpsusSppCount;

    return Column(
      children: [
        topBarTitle(),
        const SizedBox(height: 20),
        // Pie Chart
        totalCount == 0
            ? Expanded(
                child: Stack(children: [
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/svg/empty-data.svg',
                            height: 200,
                            width: 200,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Empty Data",
                            style: TextStyle(
                                fontSize: 20,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )),
                ]),
              )
            : pieChart(),
        const SizedBox(height: 20),
        // Legends
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Indicator(
              color: Color(0xFFFF9800),
              text: 'C. Carnifex',
              isSquare: false,
              size: 14,
            ),
            Indicator(
              color: Color(0xFF795548),
              text: 'S. Serrata',
              isSquare: false,
              size: 14,
            ),
            Indicator(
              color: Color(0xFFFDD835),
              text: 'V. Latreillei',
              isSquare: false,
              size: 14,
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Indicator(
              color: Color(0xFF2196F3),
              text: 'P. Pelagicus',
              isSquare: false,
              size: 14,
            ),
            Indicator(
              color: Color(0xFF9C27B0),
              text: 'Metopograpsus S.',
              isSquare: false,
              size: 14,
            ),
          ],
        ),
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
            sectionsSpace: 2,
            centerSpaceRadius: 35,
            sections: showingSections(),
          ),
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
      const fontSize = 15.0; // Increased font sizes
      const radius = 98.0;
      final shadows = [
        Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 2)
      ];

      // Title style
      TextStyle titleStyle = TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      );

      switch (i) {
        case 0:
          return PieChartSectionData(
              borderSide: BorderSide(
                color: Colors.orange[900]!,
                width: isTouched ? 4 : 0,
              ),
              radius: radius,
              badgeWidget: const PieBadge(
                  imgAsset: 'lib/assets/images/crabs/cardisomaCarnifex.jpg'),
              badgePositionPercentageOffset: 1,
              color: const Color(0xFFFF9800),
              value: widget.cardisomaCarnifexCount.toDouble(),
              title:
                  '${((widget.cardisomaCarnifexCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
              titleStyle: titleStyle);
        case 1:
          return PieChartSectionData(
              borderSide: BorderSide(
                color: Colors.brown[900]!,
                width: isTouched ? 4 : 0,
              ),
              radius: radius,
              badgeWidget: const PieBadge(
                  imgAsset: 'lib/assets/images/crabs/scyllaSerrata.jpg'),
              badgePositionPercentageOffset: 1,
              color: const Color(0xFF795548),
              value: widget.scyllaSerrataCount.toDouble(),
              title:
                  '${((widget.scyllaSerrataCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
              titleStyle: titleStyle);
        case 2:
          return PieChartSectionData(
              borderSide: BorderSide(
                color: Colors.yellow[700]!,
                width: isTouched ? 4 : 0,
              ),
              radius: radius,
              badgeWidget: const PieBadge(
                  imgAsset: 'lib/assets/images/crabs/venitusLatreillei.jpeg'),
              badgePositionPercentageOffset: 1,
              color: const Color(0xFFFDD835),
              value: widget.venitusLatreilleiCount.toDouble(),
              title:
                  '${((widget.venitusLatreilleiCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
              titleStyle: titleStyle);
        case 3:
          return PieChartSectionData(
              borderSide: BorderSide(
                color: Colors.blue[900]!,
                width: isTouched ? 4 : 0,
              ),
              radius: radius,
              badgeWidget: const PieBadge(
                  imgAsset: 'lib/assets/images/crabs/portunosPelagicus.jpg'),
              badgePositionPercentageOffset: 1,
              color: const Color(0xFF2196F3),
              value: widget.portunosPelagicusCount.toDouble(),
              title:
                  '${((widget.portunosPelagicusCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
              titleStyle: titleStyle);
        case 4:
          return PieChartSectionData(
              borderSide: BorderSide(
                color: Colors.purple[900]!,
                width: isTouched ? 4 : 0,
              ),
              radius: radius,
              badgeWidget: const PieBadge(
                  imgAsset: 'lib/assets/images/crabs/metopograpsusSp.jpeg'),
              badgePositionPercentageOffset: 1,
              color: const Color(0xFF9C27B0),
              value: widget.metopograpsusSppCount.toDouble(),
              title:
                  '${((widget.metopograpsusSppCount / getTotalCount()) * 100).toStringAsFixed(1)}%',
              titleStyle: titleStyle);
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
