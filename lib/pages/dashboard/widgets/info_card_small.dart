import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class InfoCardSmall extends StatelessWidget {
  final String title;
  final String value;
  final Color topColor;
  final bool isActive;
  final void Function() onTap;
  const InfoCardSmall(
      {super.key,
      required this.title,
      required this.value,
      required this.topColor,
      this.isActive = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isActive ? colorScheme.primary : Colors.grey,
                  width: .5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: isActive ? colorScheme.primary : Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: isActive ? colorScheme.primary : Colors.black,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
