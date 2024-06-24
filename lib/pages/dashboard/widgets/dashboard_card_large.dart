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
  Set<String> activeTitles = {};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // first row displayed
        Row(
          children: [
            InfoCard(
              title: "Scylla Serrata",
              value: "56",
              topColor: Colors.brown,
              isActive: activeTitles.contains("Scylla Serrata"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Scylla Serrata")) {
                    activeTitles.remove("Scylla Serrata");
                  } else {
                    activeTitles.add("Scylla Serrata");
                  }
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
              isActive: activeTitles.contains("Scylla Olivacea"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Scylla Olivacea")) {
                    activeTitles.remove("Scylla Olivacea");
                  } else {
                    activeTitles.add("Scylla Olivacea");
                  }
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
              isActive: activeTitles.contains("Scylla Paramamosain"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Scylla Paramamosain")) {
                    activeTitles.remove("Scylla Paramamosain");
                  } else {
                    activeTitles.add("Scylla Paramamosain");
                  }
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
              isActive: activeTitles.contains("Portunos Pelagicus"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Portunos Pelagicus")) {
                    activeTitles.remove("Portunos Pelagicus");
                  } else {
                    activeTitles.add("Portunos Pelagicus");
                  }
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
              isActive: activeTitles.contains("Zosimus Aeneus"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Zosimus Aeneus")) {
                    activeTitles.remove("Zosimus Aeneus");
                  } else {
                    activeTitles.add("Zosimus Aeneus");
                  }
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
              isActive: activeTitles.contains("Total Crabs"),
              onTap: () {
                setState(() {
                  if (activeTitles.contains("Total Crabs")) {
                    activeTitles.remove("Total Crabs");
                  } else {
                    activeTitles.add("Total Crabs");
                  }
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
                totalCrabs: totalCrabs,
              ),
            ))
      ],
    );
  }
}
