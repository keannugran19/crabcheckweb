import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/colors.dart';

class BarGraph extends StatelessWidget {
  final List totalCrabs;

  // variable for changing bar rod color
  final String activeTitle;

  const BarGraph({
    super.key,
    required this.activeTitle,
    required this.totalCrabs,
  });

  @override
  Widget build(BuildContext context) {
    // switch statement for changing colors of bar rod
    Color? rodColor;

    switch (activeTitle) {
      case 'Cardisoma Carnifex':
        rodColor = Colors.orange;
        break;
      case 'Scylla Serrata':
        rodColor = Colors.brown;
        break;
      case 'Venitus Latreillei':
        rodColor = Colors.yellow;
        break;
      case 'Portunos Pelagicus':
        rodColor = Colors.blue;
        break;
      case 'Metopograpsus Spp':
        rodColor = Colors.purple;
        break;
      case 'Total Crabs':
        rodColor = Colors.grey;
        break;
      default:
        rodColor = Colors.grey;
    }

    // Find maximum value to display in bar graph
    double maxCrabCount = totalCrabs
        .map<double>((e) => e.toDouble())
        .reduce((curr, next) => curr > next ? curr : next);
    double roundedMax = maxCrabCount;

// data to display on bargraph
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

    return Column(
      children: [
        topBarTitle(),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: maxCrabCount == 0
                ? Column(
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
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: roundedMax,
                      minY: 0,
                      barTouchData: barTouchData(),
                      titlesData: titlesData(),
                      gridData: gridData(),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                      ),
                      barGroups: myBarData.barData.map((data) {
                        return BarChartGroupData(
                          x: data.x,
                          barRods: [
                            BarChartRodData(
                              toY: data.y,
                              color: rodColor,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [
                                  rodColor ?? Colors.grey,
                                  (rodColor ?? Colors.grey).withOpacity(0.7),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: roundedMax,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 300),
                    swapAnimationCurve: Curves.easeInOutQuad,
                  ),
          ),
        ),
      ],
    );
  }
}

Widget topBarTitle() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.calendar_month, size: 16, color: Colors.grey[700]),
      const SizedBox(width: 8),
      Text(
        'Total Crabs per Month',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    ],
  );
}

BarTouchData barTouchData() {
  return BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      tooltipRoundedRadius: 8,
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          '${rod.toY.toInt()} crab/s\n',
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );
}

FlTitlesData titlesData() {
  return const FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: getTopBottomTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, interval: 5),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );
}

FlGridData gridData() {
  return FlGridData(
    show: true,
    drawHorizontalLine: true,
    drawVerticalLine: false,
    horizontalInterval: 3,
    checkToShowHorizontalLine: (value) => true,
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.grey.shade400,
        strokeWidth: 1.0,
      );
    },
  );
}

Widget getTopBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Jan', style: style);
      break;
    case 1:
      text = const Text('Feb', style: style);
      break;
    case 2:
      text = const Text('Mar', style: style);
      break;
    case 3:
      text = const Text('Apr', style: style);
      break;
    case 4:
      text = const Text('May', style: style);
      break;
    case 5:
      text = const Text('Jun', style: style);
      break;
    case 6:
      text = const Text('Jul', style: style);
      break;
    case 7:
      text = const Text('Aug', style: style);
      break;
    case 8:
      text = const Text('Sep', style: style);
      break;
    case 9:
      text = const Text('Oct', style: style);
      break;
    case 10:
      text = const Text('Nov', style: style);
      break;
    case 11:
      text = const Text('Dec', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
