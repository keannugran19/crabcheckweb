import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firestore.dart';
import '../../dashboard/pieChart/indicator.dart';
import 'crab_dropdown.dart';
import 'location_pin.dart';

class CrabMapWidget extends StatefulWidget {
  const CrabMapWidget({super.key});

  static const Map<String, String> speciesPinMap = {
    'Cardisoma Carnifex': "lib/assets/images/orange.png",
    'Venitus Latreillei': "lib/assets/images/yellow.png",
    'Scylla Serrata': "lib/assets/images/brown.png",
    'Portunos Pelagicus': "lib/assets/images/blue.png",
    'Metopograpsus Spp': "lib/assets/images/purple.png",
  };

  @override
  State<CrabMapWidget> createState() => _CrabMapWidgetState();
}

class _CrabMapWidgetState extends State<CrabMapWidget> {
  String _selectedSpecies = 'All';

  void _updateSelectedSpecies(String species) {
    setState(() {
      _selectedSpecies = species;
    });
  }

  List<Marker> _buildMarkers(List<QueryDocumentSnapshot> docs) {
    return docs
        .where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final species = data['species'] as String?;
          return _selectedSpecies == 'All' || species == _selectedSpecies;
        })
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['location'] is GeoPoint &&
              data['species'] is String &&
              data['timestamp'] is Timestamp &&
              data['image'] is String) {
            final geoPoint = data['location'] as GeoPoint;
            final species = data['species']!;
            final timestamp = data['timestamp'] as Timestamp;
            final userImage = data['image'];
            final pinImage = CrabMapWidget.speciesPinMap[species];

            if (pinImage != null) {
              final dateTime = timestamp.toDate();
              final formattedDateTime =
                  "${dateTime.month}-${dateTime.day.toString().padLeft(2, '0')}-${dateTime.year.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

              return Marker(
                point: LatLng(geoPoint.latitude, geoPoint.longitude),
                child: LocationPin(
                  species: species,
                  formattedDateTime: formattedDateTime,
                  pinImage: pinImage,
                  userImage: userImage,
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
      body: Stack(
        children: [
          // Full-screen map
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.crabs.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final markers = _buildMarkers(snapshot.data!.docs);

              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(7.2885, 125.6938),
                  initialZoom: 13,
                  minZoom: 12,
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
          // Right-side column with transparency
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Transparent white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Crab Mapping",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Filter Crabs:",
                        style: TextStyle(fontSize: 14),
                      ),
                      CrabSpeciesDropdown(
                        selectedSpecies: _selectedSpecies,
                        onSelectedSpeciesChanged: _updateSelectedSpecies,
                      ),
                      const SizedBox(height: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Indicator(
                            color: Colors.orange,
                            text: 'Cardisoma Carnifex',
                            isSquare: true,
                          ),
                          SizedBox(height: 16),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
