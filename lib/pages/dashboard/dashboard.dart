import 'package:crabcheckweb1/pages/dashboard/barGraph/bar_graph.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_large.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_small.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // all crabs count
  List<double> totalCrabs = [
    65.0,
    54.0,
    32.0,
    44.0,
    47.0,
    58.0,
    79.0,
    67.0,
    55.0,
    32.0,
    87.0,
    43.0
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              if (Responsiveness.isSmallScreen(context))
                const DashBoardPageSmallScreen()
              else
                const DashboardPageLargeScreen(),

              const SizedBox(
                height: 20,
              ),

              // bar graph
              Center(
                  child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 6),
                                color: Colors.grey.withOpacity(.1),
                                blurRadius: 12),
                          ],
                          borderRadius: BorderRadius.circular(8)),
                      child: BarGraph(
                        totalCrabs: totalCrabs,
                      )))
            ],
          ),
        )
      ],
    );
  }
}
