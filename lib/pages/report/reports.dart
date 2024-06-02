import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/pages/report/widgets/reports_table.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 30,
        ),
        ReportsTable()
      ],
    );
  }
}
