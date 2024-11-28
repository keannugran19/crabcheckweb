import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirestoreService {
  
  // call the database
  final db = FirebaseFirestore.instance;

  // call the collection
  final crabs = FirebaseFirestore.instance.collection('crabData');

  // query of getting count data from the database
  Future<int> fetchCount(String species) async {
    final query = crabs.where('species', isEqualTo: species);
    final snapshot = await query.count().get();
    return snapshot.count!;
  }

  // read data from firestore to reports table
  Stream<QuerySnapshot> getData() {
    return crabs.orderBy('timestamp', descending: true).snapshots();
  }

  // Fetch count for a specific species
  Future<int> fetchCountGraph(String species) async {
    QuerySnapshot snapshot = await db
        .collection('speciesCounts')
        .where('species', isEqualTo: species)
        .get();

    return snapshot.docs.length;
  }

  // Fetch crab data
  Future<List<QueryDocumentSnapshot>> fetchCrabData() async {
    QuerySnapshot snapshot = await crabs.get();
    return snapshot.docs;
  }

  // get address from longitude and latitude via nominatim api of openstreetmap
  Future<String> getAddressFromCoordinates(GeoPoint? location) async {
    if (location == null) return 'Unknown Location';
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json&addressdetails=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        final barangay = address['suburb'] ?? address['village'] ?? '';
        final city =
            address['city'] ?? address['town'] ?? address['municipality'] ?? '';

        return 'Brgy. ${barangay.isNotEmpty ? barangay + ', ' : ''}$city City';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Unknown Location';
    }
  }

  // filter data by year on reports table
  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredStream(
      String? selectedYear) {
    if (selectedYear == null) {
      return crabs.orderBy('timestamp', descending: true).snapshots();
    }

    final int year = int.parse(selectedYear);
    final start = DateTime(year);
    final end = DateTime(year + 1);

    return crabs
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThan: end)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // get image from firestore and display
  Widget buildImageCell(String? imageUrl) {
    return imageUrl != null
        ? Image.network(imageUrl, width: 60, height: 60)
        : const Text('No Image');
  }

  

  // Future<List<QueryDocumentSnapshot>> fetchCrabDataForYear(String year) async {
  //   DateTime startOfYear = DateTime(int.parse(year), 1, 1);
  //   DateTime endOfYear = DateTime(int.parse(year), 12, 31, 23, 59, 59);

  //   QuerySnapshot snapshot = await crabs
  //       .where('timestamp', isGreaterThanOrEqualTo: startOfYear)
  //       .where('timestamp', isLessThanOrEqualTo: endOfYear)
  //       .get();

  //   return snapshot.docs;
  // }
}
