import 'package:crabcheckweb1/pages/authentication/authentication.dart';
import 'package:crabcheckweb1/pages/dashboard/dashboard.dart';
import 'package:crabcheckweb1/pages/maps/maps.dart';
import 'package:crabcheckweb1/pages/report/reports.dart';
import 'package:crabcheckweb1/routing/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case dashboardPageRoute:
      return _getPageRoute(const DashboardPage());
    case reportsPageRoute:
      return _getPageRoute(const ReportsPage());
    case mappingPageRoute:
      return _getPageRoute(const MapsPage());
    default:
      return _getPageRoute(const DashboardPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
