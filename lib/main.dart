import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/authentication/authentication.dart';
import 'package:crabcheckweb1/pages/authentication/firebase_auth.dart';
import 'package:crabcheckweb1/widgets/custom_menu_controller.dart'
    as custom_menu_controller;
import 'package:crabcheckweb1/constants/navigation_controller.dart'
    as navigation_controller;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBlUkYyKAE5e4cSzEKOfvqCQ-7qkeq7fvE",
            authDomain: "crabcheck-c8aea.firebaseapp.com",
            projectId: "crabcheck-c8aea",
            storageBucket: "crabcheck-c8aea.appspot.com",
            messagingSenderId: "819593173831",
            appId: "1:819593173831:web:95d808519e9ec6e1514a62",
            measurementId: "G-T0JLWL3VV2"));
  } catch (e) {
    print('Firebase initialization error: $e');
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
    setState(() {});
    print(uid);
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
      theme: ThemeData(
          scaffoldBackgroundColor: colorScheme.background,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: colorScheme.onBackground),
          primaryColor: colorScheme.primary),
      navigatorKey: navigatorKey,
      home: const AuthenticationPage(),
    );
  }
}
