import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph_lists.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatefulWidget {
  const DashboardPageLargeScreen({super.key});

  @override
  State<DashboardPageLargeScreen> createState() =>
      _DashboardPageLargeScreenState();
}

class _DashboardPageLargeScreenState extends State<DashboardPageLargeScreen> {
  String activeTitle = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    late List<double> graphData;
    late String graphTitle;

    // Determine what graphTitle to put on the variable graphTitle
    if (activeTitle.contains('Scylla Serrata')) {
      graphTitle = 'Scylla Serrata';
    } else if (activeTitle.contains('Scylla Olivacea')) {
      graphTitle = 'Scylla Olivacea';
    } else if (activeTitle.contains('Scylla Paramamosain')) {
      graphTitle = 'Scylla Paramamosain';
    } else if (activeTitle.contains('Portunos Pelagicus')) {
      graphTitle = 'Portunos Pelagicus';
    } else if (activeTitle.contains('Zosimus Aeneus')) {
      graphTitle = 'Zosimus Aeneus';
    } else if (activeTitle.contains('Total Crabs')) {
      graphTitle = 'Total Crabs';
    } else {
      graphTitle = 'Total Crabs';
    }

    // Assign graph data based on the graphTitle
    switch (graphTitle) {
      case 'Scylla Serrata':
        graphData = scyllaSerrata;
        break;
      case 'Scylla Olivacea':
        graphData = scyllaOlivacea;
        break;
      case 'Scylla Paramamosain':
        graphData = scyllaParamamosain;
        break;
      case 'Portunos Pelagicus':
        graphData = portunosPelagicus;
        break;
      case 'Zosimus Aeneus':
        graphData = zosimusAeneus;
        break;
      case 'Total Crabs':
        graphData = totalCrabs;
        break;
      default:
    }

    return Column(
      children: [
        // first row displayed
        Row(
          children: [
            InfoCard(
              title: "Scylla Serrata",
              value: "56",
              topColor: Colors.brown,
              isActive: activeTitle == "Scylla Serrata",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Serrata";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Scylla Olivacea",
              value: "43",
              topColor: Colors.orange,
              isActive: activeTitle == "Scylla Olivacea",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Olivacea";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Scylla Paramamosain",
              value: "65",
              topColor: Colors.green,
              isActive: activeTitle == "Scylla Paramamosain",
              onTap: () {
                setState(() {
                  activeTitle = "Scylla Paramamosain";
                });
              },
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        // second row displayed
        Row(
          children: [
            InfoCard(
              title: "Portunos Pelagicus",
              value: "24",
              topColor: Colors.grey,
              isActive: activeTitle == "Portunos Pelagicus",
              onTap: () {
                setState(() {
                  activeTitle = "Portunos Pelagicus";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Zosimus Aeneus",
              value: "12",
              topColor: Colors.purple,
              isActive: activeTitle == "Zosimus Aeneus",
              onTap: () {
                setState(() {
                  activeTitle = "Zosimus Aeneus";
                });
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCard(
              title: "Total Crabs",
              value: "200",
              topColor: Colors.white,
              isActive: activeTitle == "Total Crabs",
              onTap: () {
                setState(() {
                  activeTitle = "Total Crabs";
                });
              },
            ),
          ],
        ),

        // BAR GRAPH
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20.0, 0.0, 2.0),
          child: Text(
            "Monthly Total",
            style: TextStyle(
              color: colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 6),
                      color: Colors.grey.withOpacity(.1),
                      blurRadius: 12),
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: BarGraph(
                totalCrabs: graphData,
              ),
            ))
      ],
    );
  }
}
