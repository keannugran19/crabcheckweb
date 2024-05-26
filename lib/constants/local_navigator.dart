import 'package:crabcheckweb1/constants/controller.dart';
import 'package:crabcheckweb1/routing/router.dart';
import 'package:crabcheckweb1/routing/routes.dart';
import 'package:flutter/material.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigationKey,
      initialRoute: dashboardPageRoute,
      onGenerateRoute: generateRoute,
    );
