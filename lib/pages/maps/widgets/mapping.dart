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
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(7.2931, 125.7004),
              width: 20,
              height: 20,
              child: Icon(Icons.location_pin),
            ),
          ],
        ),
      ],
    );
  }
}
