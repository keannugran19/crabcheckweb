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
    return const Column(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Map(),
        ))
      ],
    );
  }
}
