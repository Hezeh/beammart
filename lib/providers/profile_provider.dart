import 'dart:io';

import 'package:beammart/services/profile_service.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../models/profile.dart';

CollectionReference _profileRef =
    FirebaseFirestore.instance.collection('profile');

class ProfileProvider with ChangeNotifier {
  final ProfileService profileService = ProfileService();
  Profile? _profile;
  final User? _user;
  bool _loading = true;

  ProfileProvider(this._user) {
    if (this._user != null) {
      getBusinessProfile(this._user!);
    }
  }

  Profile? get profile => _profile;
  bool get loading => _loading;

  getBusinessProfile(User _user) async {
    // Get User Profile from firestore
    final DocumentSnapshot _profileDoc = await _profileRef.doc(_user.uid).get();
    if (_profileDoc.exists) {
      _profile = Profile.fromJson(_profileDoc.data()!);
    }
    _loading = false;
    notifyListeners();
  }

  // createBusinessProfile(Profile profile, String userId) {
  //   _profileRef.doc(userId).set(profile.toJson());
  //   notifyListeners();
  // }

  editOperatingHours({
    bool? isMondayOpen,
    bool? isTuesdayOpen,
    bool? isWednesdayOpen,
    bool? isThursdayOpen,
    bool? isFridayOpen,
    bool? isSaturdayOpen,
    bool? isSundayOpen,
    String? mondayOpeningHours,
    String? mondayClosingHours,
    String? tuesdayOpeningHours,
    String? tuesdayClosingHours,
    String? wednesdayOpeningHours,
    String? wednesdayClosingHours,
    String? thursdayOpeningHours,
    String? thursdayClosingHours,
    String? fridayOpeningHours,
    String? fridayClosingHours,
    String? saturdayOpeningHours,
    String? saturdayClosingHours,
    String? sundayOpeningHours,
    String? sundayClosingHours,
    @required String? userId,
  }) async {
    if (isMondayOpen! &&
        mondayOpeningHours != null &&
        mondayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isMondayOpen': isMondayOpen,
          'mondayOpeningHours': mondayOpeningHours,
          'mondayClosingHours': mondayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isMondayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'mondayOpeningHours': FieldValue.delete(),
          'mondayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isTuesdayOpen! &&
        tuesdayOpeningHours != null &&
        tuesdayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isTuesdayOpen': isTuesdayOpen,
          'tuesdayOpeningHours': tuesdayOpeningHours,
          'tuesdayClosingHours': tuesdayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isTuesdayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'tuesdayOpeningHours': FieldValue.delete(),
          'tuesdayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isWednesdayOpen! &&
        wednesdayOpeningHours != null &&
        wednesdayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isWednesdayOpen': isWednesdayOpen,
          'wednesdayOpeningHours': wednesdayOpeningHours,
          'wednesdayClosingHours': wednesdayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isWednesdayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'wednesdayOpeningHours': FieldValue.delete(),
          'wednesdayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isThursdayOpen! &&
        thursdayOpeningHours != null &&
        thursdayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isThursdayOpen': isThursdayOpen,
          'thursdayOpeningHours': thursdayOpeningHours,
          'thursdayClosingHours': thursdayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isThursdayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'thursdayOpeningHours': FieldValue.delete(),
          'thursdayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isFridayOpen! &&
        fridayOpeningHours != null &&
        fridayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isFridayOpen': isFridayOpen,
          'fridayOpeningHours': fridayOpeningHours,
          'fridayClosingHours': fridayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isFridayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'fridayOpeningHours': FieldValue.delete(),
          'fridayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isSaturdayOpen! &&
        saturdayOpeningHours != null &&
        saturdayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isSaturdayOpen': isSaturdayOpen,
          'saturdayOpeningHours': saturdayOpeningHours,
          'saturdayClosingHours': saturdayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isSaturdayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'saturdayOpeningHours': FieldValue.delete(),
          'saturdayClosingHours': FieldValue.delete(),
        },
      );
    }
    if (isSundayOpen! &&
        sundayOpeningHours != null &&
        sundayClosingHours != null) {
      _profileRef.doc(userId).set(
        {
          'isSundayOpen': isSundayOpen,
          'sundayOpeningHours': sundayOpeningHours,
          'sundayClosingHours': sundayClosingHours,
        },
        SetOptions(merge: true),
      );
    } else {
      _profileRef.doc(userId).set(
        {
          'isSundayOpen': false,
        },
        SetOptions(merge: true),
      );
      _profileRef.doc(userId).update(
        {
          'sundayOpeningHours': FieldValue.delete(),
          'sundayClosingHours': FieldValue.delete(),
        },
      );
    }
    final Profile? newProfile = await profileService.getCurrentProfile(userId!);
    if (newProfile != null) {
      _profile = newProfile;
    }
    notifyListeners();
  }

  addBusinessProfile(Map<String, dynamic> _json, String userId) async {
    _profileRef.doc(userId).set(_json, SetOptions(merge: true));
    final Profile? newProfile = await profileService.getCurrentProfile(userId);
    if (newProfile != null) {
      _profile = newProfile;
    }
    notifyListeners();
  }

  changeLocation(String _userId, GeoPoint _location) async {
    _profileRef
        .doc(_userId)
        .set({'gpsLocation': _location}, SetOptions(merge: true));
    _profile!.gpsLocation = _location;
    notifyListeners();
  }

  changeBusinessProfilePhoto(File? photo, String? userId) async {
    if (photo != null) {
      // Upload the photo & Get the image url
      String? _imageUrl = await uploadFile(photo);
      // Set the value
      _profile!.businessProfilePhoto = _imageUrl;
      _profileRef.doc(userId).set(
        {'businessProfilePhoto': _imageUrl},
        SetOptions(merge: true),
      );
    }
    notifyListeners();
  }
}
