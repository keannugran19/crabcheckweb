import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:crabcheckweb1/pages/maps/widgets/mapping.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

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

        const Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Map(),
        )) // Wrap Map() with Expanded
      ],
    );
  }
}
