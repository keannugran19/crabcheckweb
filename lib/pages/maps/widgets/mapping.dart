import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

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
  // initiate firestore
  final FirestoreService firestoreService = FirestoreService();

  // Total counts for each species
  int cardisomaCarnifexCount = 0;
  int scyllaSerrataCount = 0;
  int venitusLatreilleiCount = 0;
  int portunosPelagicusCount = 0;
  int metopograpsusSppCount = 0;
  int totalCount = 0;

  // dropdown value
  String _selectedSpecies = 'All';

  @override
  void initState() {
    super.initState();
    fetchAllCounts();
  }

  void _updateSelectedSpecies(String species) {
    setState(() {
      _selectedSpecies = species;
    });
    showCountDialog();
  }

  // function to get crab count
  Future<void> fetchAllCounts() async {
    Map<String, Future<int>> countFutures = {
      'Cardisoma Carnifex':
          firestoreService.fetchCountMap('Cardisoma Carnifex'),
      'Scylla Serrata': firestoreService.fetchCountMap('Scylla Serrata'),
      'Venitus Latreillei':
          firestoreService.fetchCountMap('Venitus Latreillei'),
      'Portunos Pelagicus':
          firestoreService.fetchCountMap('Portunos Pelagicus'),
      'Metopograpsus Spp': firestoreService.fetchCountMap('Metopograpsus Spp'),
    };

    Map<String, int> counts = {
      for (var entry in countFutures.entries) entry.key: await entry.value,
    };

    setState(() {
      cardisomaCarnifexCount = counts['Cardisoma Carnifex'] ?? 0;
      scyllaSerrataCount = counts['Scylla Serrata'] ?? 0;
      venitusLatreilleiCount = counts['Venitus Latreillei'] ?? 0;
      portunosPelagicusCount = counts['Portunos Pelagicus'] ?? 0;
      metopograpsusSppCount = counts['Metopograpsus Spp'] ?? 0;
      totalCount = cardisomaCarnifexCount +
          scyllaSerrataCount +
          venitusLatreilleiCount +
          portunosPelagicusCount +
          metopograpsusSppCount;
    });
  }

  Future<void> showCountDialog() async {
    int count = 0;
    String species = "";

    switch (_selectedSpecies) {
      case "Cardisoma Carnifex":
        count = cardisomaCarnifexCount;
        species = "Cardisoma Carnifex";
        break;
      case "Scylla Serrata":
        count = scyllaSerrataCount;
        species = "Scylla Serrata";
        break;
      case "Venitus Latreillei":
        count = venitusLatreilleiCount;
        species = "Venitus Latreillei";
        break;
      case "Portunos Pelagicus":
        count = portunosPelagicusCount;
        species = "Portunos Pelagicus";
        break;
      case "Metopograpsus Spp":
        count = metopograpsusSppCount;
        species = "Metopograpsus Spp";
        break;
      default:
        count = totalCount;
        species = "crabs";
    }

    var fontSize = 20.0;
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${count.toString()} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: fontSize),
                        ),
                        TextSpan(
                          text: 'total ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: fontSize),
                        ),
                        TextSpan(
                          text: '$species ',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: fontSize),
                        ),
                        TextSpan(
                          text: 'found in the map',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: fontSize),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  List<Marker> _buildMarkers(List<QueryDocumentSnapshot> docs) {
    return docs
        .where((doc) => _shouldIncludeMarker(doc))
        .map((doc) => _createMarker(doc))
        .whereType<Marker>()
        .toList();
  }

  bool _shouldIncludeMarker(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final species = data['species'] as String?;
    return _selectedSpecies == 'All' || species == _selectedSpecies;
  }

  Marker? _createMarker(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    if (_isValidData(data)) {
      final geoPoint = data['location'] as GeoPoint;
      final species = data['species']!;
      final timestamp = data['timestamp'] as Timestamp;
      final userImage = data['image'];
      final pinImage = CrabMapWidget.speciesPinMap[species];
      final address = data['address'];

      if (pinImage != null) {
        final formattedDateTime = _formatTimestamp(timestamp);
        return Marker(
          point: LatLng(geoPoint.latitude, geoPoint.longitude),
          child: LocationPin(
            species: species,
            formattedDateTime: formattedDateTime,
            pinImage: pinImage,
            userImage: userImage,
            address: address,
          ),
        );
      }
    }
    return null;
  }

  bool _isValidData(Map<String, dynamic> data) {
    return data['location'] is GeoPoint &&
        data['species'] is String &&
        data['timestamp'] is Timestamp &&
        data['image'] is String &&
        data['address'] is String;
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('MMM. dd, yyyy');
    return formatter.format(dateTime);
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
