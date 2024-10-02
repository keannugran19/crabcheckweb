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
      case 'Charybdis Feriatus':
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

    return BarChart(
      BarChartData(
        maxY: 50,
        minY: 0,
        gridData: const FlGridData(show: false), // Remove grid
        borderData: FlBorderData(
          show: false, // Remove border
        ),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Remove left titles
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: getTopBottomTitles,
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
                width: 25,
                borderRadius: BorderRadius.circular(20),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 50,
                  color: rodColorUnfilled,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

Widget getTopBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('January', style: style);
      break;
    case 1:
      text = const Text('February', style: style);
      break;
    case 2:
      text = const Text('March', style: style);
      break;
    case 3:
      text = const Text('April', style: style);
      break;
    case 4:
      text = const Text('May', style: style);
      break;
    case 5:
      text = const Text('June', style: style);
      break;
    case 6:
      text = const Text('July', style: style);
      break;
    case 7:
      text = const Text('August', style: style);
      break;
    case 8:
      text = const Text('September', style: style);
      break;
    case 9:
      text = const Text('October', style: style);
      break;
    case 10:
      text = const Text('November', style: style);
      break;
    case 11:
      text = const Text('December', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
