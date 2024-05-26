import 'package:flutter/material.dart';
import 'package:crabcheckweb1/routing/routes.dart';
import 'package:get/get.dart';

class CustomMenuController extends GetxController {
  static CustomMenuController instance = Get.find();
  var activeItem = dashboardPageRoute.obs;

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case dashboardPageRoute:
        return _customIcon(Icons.dashboard, itemName);
      case reportsPageRoute:
        return _customIcon(Icons.signal_cellular_alt_sharp, itemName);
      case mappingPageRoute:
        return _customIcon(Icons.map, itemName);
      default:
        return _customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) return Icon(icon, size: 22, color: Colors.black);

    return Icon(
      icon,
      color: isHovering(itemName) ? Colors.black : Colors.grey,
    );
  }
}
