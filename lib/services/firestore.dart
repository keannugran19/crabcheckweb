import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  // call the database
  final db = FirebaseFirestore.instance;

  // call the collection
  final crabs = FirebaseFirestore.instance.collection('crabData');
  final reports = FirebaseFirestore.instance.collection('userReports');

  // fetch crab data for a specific year
  Future<List<QueryDocumentSnapshot>> fetchCrabDataForYear(String year) async {
    if (year == "All") {
      QuerySnapshot snapshot = await crabs.get();
      return snapshot.docs;
    }
    DateTime startOfYear = DateTime(int.parse(year), 1, 1);
    DateTime endOfYear = DateTime(int.parse(year), 12, 31, 23, 59, 59);

    QuerySnapshot snapshot = await crabs
        .where('timestamp', isGreaterThanOrEqualTo: startOfYear)
        .where('timestamp', isLessThanOrEqualTo: endOfYear)
        .get();

    return snapshot.docs;
  }

  // fetch crab count per species per year
  Future<int> fetchCount(String species, String selectedYear) async {
    if (selectedYear == "All") {
      final query = crabs.where('species', isEqualTo: species);
      final snapshot = await query.get();
      return snapshot.size;
    }

    DateTime startOfYear = DateTime(int.parse(selectedYear), 1, 1);
    DateTime endOfYear = DateTime(int.parse(selectedYear), 12, 31, 23, 59, 59);

    final query = crabs
        .where('species', isEqualTo: species)
        .where('timestamp', isGreaterThanOrEqualTo: startOfYear)
        .where('timestamp', isLessThanOrEqualTo: endOfYear);

    final snapshot = await query.get();
    return snapshot.size;
  }

  // fetch crab count for mapping
  Future<int> fetchCountMap(String species) async {
    final query = crabs.where('species', isEqualTo: species);

    final snapshot = await query.get();
    return snapshot.size;
  }

  // read data from firestore to reports table
  Stream<QuerySnapshot> getData() {
    return crabs.orderBy('timestamp', descending: true).snapshots();
  }

  // filter data by year on reports table
  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredCrabReports(
      String selectedYear) {
    if (selectedYear == "All") {
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

  // filter unclassified data on reports table
  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredUnclassified(
      String selectedYear) {
    if (selectedYear == "All") {
      return reports.orderBy('timestamp', descending: true).snapshots();
    }

    final int year = int.parse(selectedYear);
    final start = DateTime(year);
    final end = DateTime(year + 1);

    return reports
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .where('timestamp', isLessThan: end)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // get image from firestore and display
  Widget buildImageCell(String? imageUrl) {
    return imageUrl != null
        ? Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )
        : const Text('No Image');
  }

  // get total count of unclassified documents
  Future<int> fetchReportCount() async {
    final query = reports;
    final snapshot = await query.count().get();
    return snapshot.count!;
  }
}
