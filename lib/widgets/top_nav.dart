import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/authentication/firebase_auth.dart';
import 'package:crabcheckweb1/widgets/responsiveness.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          const SizedBox(
            width: 10,
          ),
          userEmail == null
              ? const Text('No user is signed in.')
              : Text(
                  userEmail!,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
