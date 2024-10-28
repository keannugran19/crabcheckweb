import 'package:flutter/material.dart';

class LocationPin extends StatefulWidget {
  final String formattedDateTime;
  final String pinImage;
  final String userImage;

  const LocationPin({
    super.key,
    required this.formattedDateTime,
    required this.pinImage,
    required this.userImage,
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
            maxWidth: 200,
            maxHeight: 200,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: selected ? 200 : 40,
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: selected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          widget.userImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          widget.formattedDateTime,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ],
                    )
                  : Image.asset(widget.pinImage),
            ),
          ),
        ],
      ),
    );
  }
}
