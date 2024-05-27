import 'package:crabcheckweb1/widgets/large_screen.dart';
import 'package:crabcheckweb1/widgets/medium_screen.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:crabcheckweb1/widgets/side_menu.dart';
import 'package:crabcheckweb1/widgets/small_screen.dart';
import 'package:crabcheckweb1/widgets/top_nav.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: topNavigationBar(context, scaffoldKey),
        drawer: const Drawer(
          child: SideMenu(),
        ),
        body: const Responsiveness(
          largeScreen: LargeScreen(),
          mediumScreen: MediumScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
