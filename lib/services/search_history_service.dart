import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _pastSearchesDb =
    FirebaseFirestore.instance.collection('pastSearches');

class SearchHistoryService {
  // Stream<List<Map<String, dynamic>>> _pastSearches;

  Stream<DocumentSnapshot> getPastSearches(String? userId) {
    final docs = _pastSearchesDb.doc(userId).snapshots();
    return docs;
  }
}
