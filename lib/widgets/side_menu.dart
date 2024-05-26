import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:crabcheckweb1/routing/routes.dart';
import 'package:crabcheckweb1/widgets/side_menu_item.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          if (Responsiveness.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Center(
                        child: Text(
                          "CrabCheck",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 48),
                  ],
                ),
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItems
                .map((itemName) => SideMenuItem(
                    itemName: itemName == authenticationPageRoute
                        ? "Log out"
                        : itemName,
                    onTap: () {
                      if (itemName == authenticationPageRoute) {}
                      if (!menuController.isActive(itemName)) {
                        navigationController.navigateTo(itemName);
                        menuController.changeActiveItemTo(itemName);
                        if (Responsiveness.isSmallScreen(context)) {
                          Get.back();
                        }
                      }
                    }))
                .toList(),
          )
        ],
      ),
    );
  }
}
