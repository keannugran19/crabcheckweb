import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/dashboard/pieChart/indicator.dart';
import 'package:crabcheckweb1/pages/maps/widgets/location_pin.dart';
import 'package:crabcheckweb1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrabMapWidget extends StatefulWidget {
  const CrabMapWidget({super.key});

  // Define species pin color
  static const Map<String, String> speciesPinMap = {
    // 'Charybdis Feriatus': "lib/assets/images/orange.png",
    'Venitus Latreillei': "lib/assets/images/yellow.png",
    'Scylla Serrata': "lib/assets/images/brown.png",
    'Portunos Pelagicus': "lib/assets/images/darkgray.png",
    'Metopograpsus Spp': "lib/assets/images/purple.png",
  };

  @override
  State<CrabMapWidget> createState() => _CrabMapWidgetState();
}

class _CrabMapWidgetState extends State<CrabMapWidget> {
  bool selected = false;

  // Function to build markers
  List<Marker> _buildMarkers(List<QueryDocumentSnapshot> docs) {
    return docs
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['location'] is GeoPoint &&
              data['species'] is String &&
              data['timestamp'] is Timestamp &&
              data['image'] is String) {
            // Check for Timestamp type
            final geoPoint = data['location'] as GeoPoint;
            final species = data['species'];
            final timestamp = data['timestamp'] as Timestamp;
            final userImage = data['image'];
            final pinImage = CrabMapWidget.speciesPinMap[species];

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
                  child: LocationPin(
                    formattedDateTime: formattedDateTime,
                    pinImage: pinImage,
                    userImage: userImage,
                  ));
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
      body: Row(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(10),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 8,
              //     spreadRadius: 2,
              //   ),
              // ],
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
                    // SizedBox(height: 4),
                    // Indicator(
                    //   color: Colors.orange,
                    //   text: 'Charybdis Feriatus',
                    //   isSquare: true,
                    // ),
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
        ],
      ),
    );
  }
}
