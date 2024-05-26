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
      title: Row(
        children: [
          Visibility(
              visible: !Responsiveness.isSmallScreen(context),
              child: Text(
                "CrabCheck",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Expanded(child: Container()),
          IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {}),
          Container(
            width: 1,
            height: 22,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "Keannu Gran",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: colorScheme.tertiary.withOpacity(.5),
                borderRadius: BorderRadius.circular(30)),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundColor: colorScheme.background,
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: Colors.white,
    );
