import 'package:flutter/material.dart';

const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;

class Responsiveness extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const Responsiveness({
    super.key,
    required this.largeScreen,
    required this.mediumScreen,
    required this.smallScreen,
  });

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < smallScreenSize;

  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize;
  // && MediaQuery.of(context).size.width < largeScreenSize;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeScreenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width > mediumScreenSize) {
          return largeScreen;
        } else if (width <= largeScreenSize && width >= smallScreenSize) {
          return mediumScreen;
        } else {
          return smallScreen;
        }
      },
    );
  }
}
