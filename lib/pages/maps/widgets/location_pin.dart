import 'package:crabcheckweb1/constants/colors.dart';
import 'package:flutter/material.dart';

class LocationPin extends StatefulWidget {
  final String formattedDateTime;
  final String species;
  final String address;
  final String pinImage;
  final String userImage;

  const LocationPin({
    super.key,
    required this.formattedDateTime,
    required this.pinImage,
    required this.userImage,
    required this.species,
    required this.address,
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
            maxWidth: 160,
            maxHeight: 160,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: selected ? 160 : 40,
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
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.network(
                              widget.userImage,
                              width: 100,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.species,
                              style: const TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.address,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              widget.formattedDateTime,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 12),
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
