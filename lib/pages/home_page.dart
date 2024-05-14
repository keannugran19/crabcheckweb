import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/widgets/large_screen.dart';
import 'package:crabcheckweb1/widgets/medium_screen.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:crabcheckweb1/widgets/small_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.background,
        ),
        body: const Responsiveness(
          largeScreen: LargeScreen(),
          mediumScreen: MediumScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
