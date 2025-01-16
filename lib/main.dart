import 'dart:developer' as devtools;
import 'package:crabcheckweb1/constants/theme_data.dart';
import 'package:crabcheckweb1/pages/authentication/authentication.dart';
import 'package:crabcheckweb1/pages/authentication/firebase_auth.dart';
import 'package:crabcheckweb1/widgets/custom_menu_controller.dart'
    as custom_menu_controller;
import 'package:crabcheckweb1/constants/navigation_controller.dart'
    as navigation_controller;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    devtools.log('Firebase initialization error: $e');
  }

  Get.put(custom_menu_controller.CustomMenuController());
  Get.put(navigation_controller.NavigationController());

  runApp(const CrabCheckWeb());
}

class CrabCheckWeb extends StatefulWidget {
  const CrabCheckWeb({super.key});

  @override
  State<CrabCheckWeb> createState() => _CrabCheckWebState();
}

class _CrabCheckWebState extends State<CrabCheckWeb> {
  final GlobalKey<NavigatorState> navigatorKey = Get.key;

  Future getUserInfo() async {
    await getUser();
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Crabcheck Dashboard",
        theme: ThemeClass.theme,
        navigatorKey: navigatorKey,
        home: const AuthenticationPage());
  }
}
