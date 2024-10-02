import 'package:crabcheckweb1/pages/report/widgets/reports_table.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
        ),
        ReportsTable()
      ],
    );
  }
}
