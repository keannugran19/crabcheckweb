import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class LocationPin extends StatefulWidget {
  final String formattedDateTime;
  final String species;
  final String pinImage;
  final String userImage;

  const LocationPin({
    super.key,
    required this.formattedDateTime,
    required this.pinImage,
    required this.userImage,
    required this.species,
  });

  @override
  State<LocationPin> createState() => _LocationPinState();
}

class _LocationPinState extends State<LocationPin> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          OverflowBox(
            maxWidth: 150,
            maxHeight: 150,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: selected ? 150 : 40,
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: selected
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              widget.userImage,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.formattedDateTime,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12),
                            ),
                            Text(
                              widget.species,
                              style: const TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Image.asset(widget.pinImage),
            ),
          ),
        ],
      ),
    );
  }
}
