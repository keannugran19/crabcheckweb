import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/widgets/info_card.dart';
import 'package:flutter/material.dart';

class DashboardPageLargeScreen extends StatelessWidget {
  const DashboardPageLargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
            title: "Edible Crabs found",
            value: "56",
            onTap: () {},
            topColor: colorScheme.primary),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "Inedible Crabs found",
          value: "17",
          topColor: Colors.red,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
        InfoCard(
          title: "Total Crabs found",
          value: "120",
          topColor: colorScheme.tertiary,
          onTap: () {},
        ),
        SizedBox(
          width: width / 64,
        ),
      ],
    );
  }
}
