import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const CrabCheckWeb());
}

class CrabCheckWeb extends StatelessWidget {
  const CrabCheckWeb({super.key});

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
      home: HomePage(),
    );
  }
}
