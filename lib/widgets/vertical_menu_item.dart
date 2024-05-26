import 'package:flutter/material.dart';
import 'package:crabcheckweb1/constants/controller.dart';
import 'package:get/get.dart';

class VerticalMenuItem extends StatelessWidget {
  final String itemName;
  final Function()? onTap;
  const VerticalMenuItem({super.key, required this.itemName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        onHover: (value) {
          value
              ? menuController.onHover(itemName)
              : menuController.onHover("not hovering");
        },
        child: Obx(() => Container(
              color: menuController.isHovering(itemName)
                  ? Colors.grey.withOpacity(.1)
                  : Colors.transparent,
              child: Row(
                children: [
                  Visibility(
                    visible: menuController.isHovering(itemName) ||
                        menuController.isActive(itemName),
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      width: 3,
                      height: 72,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: menuController.returnIconFor(itemName),
                        ),
                        if (!menuController.isActive(itemName))
                          Flexible(
                              child: Text(
                            itemName,
                            style: TextStyle(
                              color: menuController.isHovering(itemName)
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ))
                        else
                          Flexible(
                              child: Text(
                            itemName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
