import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_large.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/dashboard_card_small.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: Responsiveness.isSmallScreen(context) ? 56 : 6),
                  child: Text(
                    menuController.activeItem.value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary),
                  ),
                ),
              ],
            )),
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
