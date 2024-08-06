import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(7.2885, 125.6938),
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: const LatLng(7.2931, 125.7004),
              width: 100,
              height: 100,
              child: Image.asset("lib/assets/images/crab_brown_loc.png"),
            ),
            Marker(
              point: const LatLng(7.2896, 125.6945),
              width: 100,
              height: 100,
              child: Image.asset("lib/assets/images/crab_green_loc.png"),
            ),
            Marker(
              point: const LatLng(7.2830, 125.6894),
              width: 100,
              height: 100,
              child: Image.asset("lib/assets/images/crab_grey_loc.png"),
            ),
            Marker(
              point: const LatLng(7.2891, 125.6942),
              width: 100,
              height: 100,
              child: Image.asset("lib/assets/images/crab_orange_loc.png"),
            ),
            Marker(
              point: const LatLng(7.2928, 125.6965),
              width: 100,
              height: 100,
              child: Image.asset("lib/assets/images/crab_purple_loc.png"),
            ),
          ],
        ),
      ],
    );
  }
}
