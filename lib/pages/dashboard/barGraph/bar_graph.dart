import 'package:crabcheckweb1/constants/colors.dart';
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
      maxY: 150,
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true, getTitlesWidget: getTopBottomTitles)),
      ),
      barGroups: myBarData.barData
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: colorScheme.secondary,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, toY: 150, color: Colors.grey[200]))
              ]))
          .toList(),
    ));
  }
}

Widget getTopBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 1:
      text = const Text(
        'F',
        style: style,
      );
      break;
    case 2:
      text = const Text(
        'M',
        style: style,
      );
      break;
    case 3:
      text = const Text(
        'A',
        style: style,
      );
      break;
    case 4:
      text = const Text(
        'M',
        style: style,
      );
      break;
    case 5:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 6:
      text = const Text(
        'J',
        style: style,
      );
      break;
    case 7:
      text = const Text(
        'A',
        style: style,
      );
      break;
    case 8:
      text = const Text(
        'S',
        style: style,
      );
      break;
    case 9:
      text = const Text(
        'O',
        style: style,
      );
      break;
    case 10:
      text = const Text(
        'N',
        style: style,
      );
      break;
    case 11:
      text = const Text(
        'D',
        style: style,
      );
      break;
    default:
      text = const Text(
        '',
        style: style,
      );
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
