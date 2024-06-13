import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph.dart';
import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph_lists.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_dropdown.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatefulWidget {
  const DashboardPageLargeScreen({super.key});

  @override
  State<DashboardPageLargeScreen> createState() =>
      _DashboardPageLargeScreenState();
}

class _DashboardPageLargeScreenState extends State<DashboardPageLargeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // dropdown menu to filter species
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownMenuDashboard(),
          ],
        ),
        const SizedBox(
          height: 20,
        ),

        // first row displayed
        Row(
          children: [
            const InfoCard(
                title: "Scylla Serrata", value: "56", topColor: Colors.brown),
            SizedBox(
              width: width / 64,
            ),
            const InfoCard(
              title: "Scylla Olivacea",
              value: "43",
              topColor: Colors.orange,
            ),
            SizedBox(
              width: width / 64,
            ),
            const InfoCard(
              title: "Scylla Paramamosain",
              value: "65",
              topColor: Colors.green,
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        // second row displayed
        Row(
          children: [
            const InfoCard(
              title: "Portunos Pelagicus",
              value: "24",
              topColor: Colors.grey,
            ),
            SizedBox(
              width: width / 64,
            ),
            const InfoCard(
              title: "Zosimus Aeneus",
              value: "12",
              topColor: Colors.purple,
            ),
            SizedBox(
              width: width / 64,
            ),
            const InfoCard(
              title: "Total Crabs",
              value: "200",
              topColor: Colors.white,
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
