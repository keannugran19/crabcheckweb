import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
    Color? rodColorUnfilled;

    switch (activeTitle) {
      case 'Cardisoma Carnifex':
        rodColor = Colors.orange;
        rodColorUnfilled = Colors.orange[200];
        break;
      case 'Scylla Serrata':
        rodColor = Colors.brown;
        rodColorUnfilled = Colors.brown[200];
        break;
      case 'Venitus Latreillei':
        rodColor = Colors.yellow;
        rodColorUnfilled = Colors.yellow[200];
        break;
      case 'Portunos Pelagicus':
        rodColor = Colors.blue;
        rodColorUnfilled = Colors.blue[200];
        break;
      case 'Metopograpsus Spp':
        rodColor = Colors.purple;
        rodColorUnfilled = Colors.purple[200];
        break;
      case 'Total Crabs':
        rodColor = Colors.grey;
        rodColorUnfilled = Colors.white;
        break;
      default:
        rodColor = Colors.grey;
        rodColorUnfilled = Colors.white;
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
        Row(
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
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: roundedMax,
                minY: 0,
                barTouchData: BarTouchData(
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
                ),
                titlesData: const FlTitlesData(
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
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  checkToShowHorizontalLine: (value) => true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade400, // Darker color
                      strokeWidth: 1.0, // Slightly thinner
                    );
                  },
                ),
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
                          color: rodColorUnfilled,
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

Widget getTopBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('J', style: style);
      break;
    case 1:
      text = const Text('F', style: style);
      break;
    case 2:
      text = const Text('M', style: style);
      break;
    case 3:
      text = const Text('A', style: style);
      break;
    case 4:
      text = const Text('M', style: style);
      break;
    case 5:
      text = const Text('J', style: style);
      break;
    case 6:
      text = const Text('J', style: style);
      break;
    case 7:
      text = const Text('A', style: style);
      break;
    case 8:
      text = const Text('S', style: style);
      break;
    case 9:
      text = const Text('O', style: style);
      break;
    case 10:
      text = const Text('N', style: style);
      break;
    case 11:
      text = const Text('D', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
