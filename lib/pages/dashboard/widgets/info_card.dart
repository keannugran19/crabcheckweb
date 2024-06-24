import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final String title;
  final String value;
  final Color topColor;
  final bool isActive;
  final Function() onTap;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.topColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: Colors.grey.withOpacity(.1),
                    blurRadius: 12),
              ],
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: widget.topColor,
                      height: 5,
                    ),
                  )
                ],
              ),
              Expanded(child: Container()),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "${widget.title}\n",
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.isActive
                                ? colorScheme.primary
                                : colorScheme.onBackground)),
                    TextSpan(
                        text: widget.value,
                        style: TextStyle(
                            fontSize: 40,
                            color: widget.isActive
                                ? colorScheme.primary
                                : colorScheme.onBackground)),
                  ])),
              Expanded(child: Container())
            ],
          ),
        ),
      ),
    );
  }
}
