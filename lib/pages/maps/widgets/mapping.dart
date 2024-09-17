import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/indicator.dart';
import 'package:crabcheckweb1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrabMapWidget extends StatelessWidget {
  const CrabMapWidget({super.key});

  // Define species pin color
  static const Map<String, String> speciesPinMap = {
    'Charybdis Feriatus': "lib/assets/images/orange.png",
    'Venitus Latreillei': "lib/assets/images/yellow.png",
    'Scylla Serrata': "lib/assets/images/brown.png",
    'Portunos Pelagicus': "lib/assets/images/darkgray.png",
    'Metopograpsus Spp': "lib/assets/images/purple.png",
  };

  // Function to build markers
  List<Marker> _buildMarkers(List<QueryDocumentSnapshot> docs) {
    return docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['location'] is GeoPoint &&
              data['species'] is String &&
              data['timestamp'] is Timestamp) {
            // Check for Timestamp type
            final geoPoint = data['location'] as GeoPoint;
            final species = data['species'];
            final timestamp = data['timestamp'] as Timestamp;
            final pinImage = speciesPinMap[species];

            if (pinImage != null) {
              // Convert Timestamp to DateTime
              final dateTime = timestamp.toDate();

              // Format date and time
              final formattedDate =
                  "${dateTime.month}-${dateTime.day.toString().padLeft(2, '0')}-${dateTime.year.toString().padLeft(2, '0')}";
              final formattedTime =
                  "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
              final formattedDateTime = "$formattedDate $formattedTime";

              return Marker(
                point: LatLng(geoPoint.latitude, geoPoint.longitude),
                width: 100,
                height: 100,
                child: Tooltip(
                  message: formattedDateTime,
                  verticalOffset: 20,
                  preferBelow: false,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(pinImage),
                ),
              );
            }
          }
          return null;
        })
        .whereType<Marker>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
        child: Row(
          children: [
            // map view
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.crabs.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final markers = _buildMarkers(snapshot.data!.docs);

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
            // Enhanced Legend UI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Edible Section
                      Text(
                        'Edible:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Indicator(
                        color: Colors.orange,
                        text: 'Charybdis Feriatus',
                        isSquare: true,
                      ),
                      SizedBox(height: 4),
                      Indicator(
                        color: Colors.brown,
                        text: 'Scylla Serrata',
                        isSquare: true,
                      ),
                      SizedBox(height: 4),
                      Indicator(
                        color: Colors.blue,
                        text: 'Portunos Pelagicus',
                        isSquare: true,
                      ),

                      SizedBox(height: 16),

                      // Inedible Section
                      Text(
                        'Inedible:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Indicator(
                        color: Colors.yellow,
                        text: 'Venitus Latreillei',
                        isSquare: true,
                      ),
                      SizedBox(height: 4),
                      Indicator(
                        color: Colors.purple,
                        text: 'Metopograpsus Spp',
                        isSquare: true,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
