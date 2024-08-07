import 'package:crabcheckweb1/constants/local_navigator.dart';
import 'package:crabcheckweb1/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class MediumScreen extends StatelessWidget {
  const MediumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: SideMenu(),
        ),
        Expanded(
          flex: 3,
          child: localNavigator(),
        )
      ],
    );
  }
}
