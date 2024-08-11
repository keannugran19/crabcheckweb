import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartDisplay extends StatelessWidget {
  final int scyllaSerrataCount;
  final int scyllaOlivaceaCount;
  final int scyllaParamamosainCount;
  final int portunosPelagicusCount;
  final int zosimusAeneusCount;

  const PieChartDisplay({
    super.key,
    required this.scyllaSerrataCount,
    required this.scyllaOlivaceaCount,
    required this.scyllaParamamosainCount,
    required this.portunosPelagicusCount,
    required this.zosimusAeneusCount,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
        swapAnimationDuration: const Duration(milliseconds: 750),
        swapAnimationCurve: Curves.easeInOutQuint,
        PieChartData(sections: [
          PieChartSectionData(
              value: scyllaSerrataCount.toDouble(), color: Colors.brown),
          PieChartSectionData(
              value: scyllaOlivaceaCount.toDouble(), color: Colors.orange),
          PieChartSectionData(
              value: scyllaParamamosainCount.toDouble(), color: Colors.green),
          PieChartSectionData(
              value: portunosPelagicusCount.toDouble(), color: Colors.grey),
          PieChartSectionData(
              value: zosimusAeneusCount.toDouble(), color: Colors.purple),
        ]));
  }
}
