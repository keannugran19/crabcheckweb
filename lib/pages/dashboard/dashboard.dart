import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_large.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_small.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                const DashboardPageLargeScreen()
            ],
          ),
        )
      ],
    );
  }
}
