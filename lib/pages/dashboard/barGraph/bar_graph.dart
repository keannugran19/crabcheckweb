import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarGraph extends StatelessWidget {
  final List totalCrabs;
  const BarGraph({super.key, required this.totalCrabs});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        januaryTotal: totalCrabs[0],
        februaryTotal: totalCrabs[1],
        marchTotal: totalCrabs[2],
        aprilTotal: totalCrabs[3],
        mayTotal: totalCrabs[4],
        juneTotal: totalCrabs[5],
        julyTotal: totalCrabs[6],
        augustTotal: totalCrabs[7],
        septemberTotal: totalCrabs[8],
        octoberTotal: totalCrabs[9],
        novemberTotal: totalCrabs[10],
        decemberTotal: totalCrabs[11]);

    myBarData.initializeBarData();

    return BarChart(BarChartData(
      maxY: 100,
      minY: 0,
      barGroups: myBarData.barData
          .map((data) => BarChartGroupData(
              x: data.x, barRods: [BarChartRodData(toY: data.y)]))
          .toList(),
    ));
  }
}
