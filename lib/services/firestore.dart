import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // call the database
  final db = FirebaseFirestore.instance;

  // call the collection
  final CollectionReference crabs =
      FirebaseFirestore.instance.collection('crabData');

  // query of getting count data from the database
  Future<int> fetchCount(String species) async {
    final crabRef = db.collection('crabData');
    final query = crabRef.where('species', isEqualTo: species);
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
    QuerySnapshot snapshot = await db.collection('crabData').get();
    return snapshot.docs;
  }
}
