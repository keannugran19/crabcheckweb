import 'package:crabcheckweb1/pages/maps/widgets/mapping.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Map()
      ],
    );
  }
}
