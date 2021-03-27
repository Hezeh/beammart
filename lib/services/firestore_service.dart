import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _deviceProfileDb =
    FirebaseFirestore.instance.collection('deviceProfile');
final CollectionReference _pastSearchesDb =
    FirebaseFirestore.instance.collection('pastSearches');

class FirestoreService {
  // Create or update device Profile
  Future<void> createDeviceProfile(String deviceId, Map<String, dynamic> data) {
    return _deviceProfileDb.doc(deviceId).set(data, SetOptions(merge: true));
  }

  // Get user profile;
  Future<Map<String, dynamic>?> fetchDeviceProfile(String? deviceId) async {
    // Check whether a doc exists
    final _snapshot = await _deviceProfileDb.doc(deviceId).get();
    if (_snapshot.exists) {
      final _data = _snapshot.data();
      return _data;
    }
    return null;
  }

  saveSearches(String? deviceId, String query) {
    _pastSearchesDb.doc(deviceId).set({
      'queries': FieldValue.arrayUnion([
        {
          'timeStamp': DateTime.now(),
          'query': query,
        }
      ])
    }, SetOptions(merge: true));
  }
}
