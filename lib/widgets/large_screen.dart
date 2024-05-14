import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class LargeScreen extends StatelessWidget {
  const LargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: colorScheme.primary,
          ),
        ),
        Expanded(
            flex: 5,
            child: Container(
              color: colorScheme.secondary,
            ))
      ],
    );
  }
}
