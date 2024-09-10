import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/indicator.dart';
import 'package:crabcheckweb1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrabMapWidget extends StatelessWidget {
  const CrabMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.crabs.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                late String pinColor;

                final species =
                    firestoreService.crabs.doc('species').toString();

                switch (species) {
                  case 'Charybdis Feriatus':
                    pinColor = "lib/assets/images/crab_brown_loc.png";
                    break;
                  default:
                    pinColor = "lib/assets/images/crab_brown_loc.png";
                }

                final markers = snapshot.data!.docs
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      if (data['location'] is GeoPoint) {
                        final geoPoint = data['location'] as GeoPoint;
                        return Marker(
                          point: LatLng(geoPoint.latitude, geoPoint.longitude),
                          width: 100,
                          height: 100,
                          child: InkWell(
                            child: Image.asset(pinColor),
                          ),
                        );
                      }
                      return null;
                    })
                    .whereType<Marker>()
                    .toList();

                return FlutterMap(
                  options: const MapOptions(
                    initialCenter: LatLng(7.2885, 125.6938),
                    initialZoom: 15,
                    minZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Text(
                "Crab Mapping",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                      color: Colors.brown,
                      text: 'Scylla Serrata',
                      isSquare: true),
                  SizedBox(height: 4),
                  Indicator(
                      color: Colors.orange,
                      text: 'Scylla Olivacea',
                      isSquare: true),
                  SizedBox(height: 4),
                  Indicator(
                      color: Colors.green,
                      text: 'Scylla Paramamosain',
                      isSquare: true),
                  SizedBox(height: 4),
                  Indicator(
                      color: Colors.blue,
                      text: 'Portunos Pelagicus',
                      isSquare: true),
                  SizedBox(height: 4),
                  Indicator(
                      color: Colors.purple,
                      text: 'Zosimus Aeneus',
                      isSquare: true),
                  SizedBox(height: 18),
                ],
              ),
            ],
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}
