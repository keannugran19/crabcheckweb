import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String image;
  final String title;
  final int value;
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
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.darken,
              ),
              onError: (exception, stackTrace) {
                print('Image Error: $exception');
              },
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: topColor,
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
                      text: "$title\n",
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              isActive ? colorScheme.primary : Colors.white)),
                  TextSpan(
                      text: value.toString(),
                      style: TextStyle(
                          fontSize: 40,
                          color:
                              isActive ? colorScheme.primary : Colors.white)),
                ])),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}
