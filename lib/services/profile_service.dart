import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile.dart';

final CollectionReference _db =
    FirebaseFirestore.instance.collection('consumers');

class ProfileService {
  Future<Profile?> getCurrentProfile(String userId) async {
    // final DocumentSnapshot profile =
    await _db.doc(userId).get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> _snapData =
            snapshot.data() as Map<String, dynamic>;
        return Profile.fromJson(_snapData);
      } else {
        return null;
      }
    });
    // final _profileData = profile.data();
    // if (profile != null) {
    //   return Profile.fromJson(profile.data() as Map<String, dynamic>);
    // }
    // return profile;
    // return null;
  }

  Future<Profile?> getMerchantCurrentProfile(String userId) async {
    final CollectionReference _merchantDb =
        FirebaseFirestore.instance.collection('profile');
    final DocumentSnapshot profile = await _merchantDb.doc(userId).get();
    if (profile.data() != null) {
      return Profile.fromJson(profile.data()! as Map<String, dynamic>);
    }
    return null;
  }
}
