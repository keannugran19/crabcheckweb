import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:flutter/material.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !Responsiveness.isSmallScreen(context)
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 14),
                  child: Image.asset(
                    "lib/assets/images/crabLogo.png",
                    width: 42,
                  ),
                )
              ],
            )
          : IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu)),
      elevation: 0,
    );
