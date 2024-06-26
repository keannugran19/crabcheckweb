import 'package:flutter/material.dart';
import 'info_card_small.dart';

class DashBoardPageSmallScreen extends StatelessWidget {
  const DashBoardPageSmallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 600,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const InfoCardSmall(
            title: "Scylla Serrata",
            value: "56",
          ),
          SizedBox(
            height: width / 64,
          ),
          const InfoCardSmall(
            title: "Scylla Olivacea",
            value: "17",
          ),
          SizedBox(
            height: width / 64,
          ),
          const InfoCardSmall(
            title: "Scylla Paramamosain",
            value: "120",
          ),
          SizedBox(
            height: width / 64,
          ),
          const InfoCardSmall(
            title: "Portunos Pelagicus",
            value: "120",
          ),
          SizedBox(
            height: width / 64,
          ),
          const InfoCardSmall(
            title: "Zosimus Aeneus",
            value: "120",
          ),
          SizedBox(
            height: width / 64,
          ),
          const InfoCardSmall(
            title: "Total",
            value: "120",
          ),
        ],
      ),
    );
  }
}
