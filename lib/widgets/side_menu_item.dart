import 'package:crabcheckweb1/widgets/horizontal_menu_item.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:crabcheckweb1/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final Function() onTap;
  const SideMenuItem({super.key, required this.itemName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (Responsiveness.isMediumScreen(context)) {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}
