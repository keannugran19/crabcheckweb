import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_dropdown.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatelessWidget {
  const DashboardPageLargeScreen({super.key});

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
              value: "17",
              topColor: Colors.orange,
            ),
            SizedBox(
              width: width / 64,
            ),
            const InfoCard(
              title: "Scylla Paramamosain",
              value: "120",
              topColor: Colors.green,
            ),
          ],
        ),

        const SizedBox(
          height: 20,
        ),

        // second row displayed
        Center(
          child: Row(
            children: [
              const InfoCard(
                title: "Portunos Pelagicus",
                value: "120",
                topColor: Colors.grey,
              ),
              SizedBox(
                width: width / 64,
              ),
              const InfoCard(
                title: "Zosimus Aeneus",
                value: "120",
                topColor: Colors.purple,
              ),
              SizedBox(
                width: width / 64,
              ),
              const InfoCard(
                title: "Total Crabs",
                value: "120",
                topColor: Colors.white,
              ),
            ],
          ),
        )
      ],
    );
  }
}
