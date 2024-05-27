import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

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
            ))
      ],
    );
  }
}
