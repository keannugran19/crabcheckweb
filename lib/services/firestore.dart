import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference crabs =
      FirebaseFirestore.instance.collection('crabs');
}
