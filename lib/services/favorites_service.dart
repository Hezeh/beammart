import 'package:beammart/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isFavorite(String _userId, String _itemId) async {
  final _doc = await FirebaseFirestore.instance
      .collection('consumers')
      .doc(_userId)
      .collection('favorites')
      .doc(_itemId)
      .get();
  if (_doc.exists) {
    return true;
  } else {
    return false;
  }
}

Future<void> createFavorite(
  String _userId,
  String _itemId,
) async {
  final DocumentSnapshot _snapshot =
      await FirebaseFirestore.instance.collection('items').doc(_itemId).get();
  final _data = _snapshot.data()! as Map<String, dynamic>;
  final _docRef = FirebaseFirestore.instance
      .collection('consumers')
      .doc(_userId)
      .collection('favorites')
      .doc(_itemId);
  _docRef.set(
    _data,
    SetOptions(merge: true),
  );
}

Future<void> deleteFavorite(
  String _userId,
  String _itemId,
) async {
  final _docRef = FirebaseFirestore.instance
      .collection('consumers')
      .doc(_userId)
      .collection('favorites')
      .doc(_itemId);
  _docRef.delete();
}

// Stream<List<Item>> getAllFavorites(
//   String _userId,
//   String _itemId,
// ) async* {
//   final _docRef = FirebaseFirestore.instance
//       .collection('consumers')
//       .doc(_userId)
//       .collection('favorites');
//   final _data = _docRef.snapshots();
//   yield _data;
// }
