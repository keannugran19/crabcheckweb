import 'package:flutter/material.dart';
import 'info_card_small.dart';

class DashBoardPageSmallScreen extends StatelessWidget {
  const DashBoardPageSmallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 400,
      child: Column(
        children: [
          InfoCardSmall(
            title: "Edible Crabs",
            value: "56",
            onTap: () {},
            isActive: true,
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: "Inedible Crabs",
            value: "17",
            onTap: () {},
          ),
          SizedBox(
            height: width / 64,
          ),
          InfoCardSmall(
            title: "Total Crabs",
            value: "120",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
