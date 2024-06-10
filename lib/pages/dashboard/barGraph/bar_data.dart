import 'package:crabcheckweb1/pages/dashboard/barGraph/individual_bar.dart';

class BarData {
  final double januaryTotal;
  final double februaryTotal;
  final double marchTotal;
  final double aprilTotal;
  final double mayTotal;
  final double juneTotal;
  final double julyTotal;
  final double augustTotal;
  final double septemberTotal;
  final double octoberTotal;
  final double novemberTotal;
  final double decemberTotal;

  BarData(
      {required this.januaryTotal,
      required this.februaryTotal,
      required this.marchTotal,
      required this.aprilTotal,
      required this.mayTotal,
      required this.juneTotal,
      required this.julyTotal,
      required this.augustTotal,
      required this.septemberTotal,
      required this.octoberTotal,
      required this.novemberTotal,
      required this.decemberTotal});

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData() {
    barData = [
      // months
      IndividualBar(x: 0, y: januaryTotal),
      IndividualBar(x: 1, y: februaryTotal),
      IndividualBar(x: 2, y: marchTotal),
      IndividualBar(x: 3, y: aprilTotal),
      IndividualBar(x: 4, y: mayTotal),
      IndividualBar(x: 5, y: juneTotal),
      IndividualBar(x: 6, y: julyTotal),
      IndividualBar(x: 7, y: augustTotal),
      IndividualBar(x: 8, y: septemberTotal),
      IndividualBar(x: 9, y: octoberTotal),
      IndividualBar(x: 10, y: novemberTotal),
      IndividualBar(x: 11, y: decemberTotal),
    ];
  }
}
