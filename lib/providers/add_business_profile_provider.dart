import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/profile.dart';
import '../utils/upload_files_util.dart';

class AddBusinessProfileProvider with ChangeNotifier {
  Profile _profile = Profile();

  Profile get profile => _profile;

  addOperatingTime({
    bool? isMondayOpen,
    bool? isTuesdayOpen,
    bool? isWednesdayOpen,
    bool? isThursdayOpen,
    bool? isFridayOpen,
    bool? isSaturdayOpen,
    bool? isSundayOpen,
    String? mondayOpeningTime,
    String? mondayClosingTime,
    String? tuesdayOpeningTime,
    String? tuesdayClosingTime,
    String? wednesdayOpeningTime,
    String? wednesdayClosingTime,
    String? thursdayOpeningTime,
    String? thursdayClosingTime,
    String? fridayOpeningTime,
    String? fridayClosingTime,
    String? saturdayOpeningTime,
    String? saturdayClosingTime,
    String? sundayOpeningTime,
    String? sundayClosingTime,
  }) {
    if (isMondayOpen != null) {
      _profile.isMondayOpen = isMondayOpen;
      if (isMondayOpen &&
          mondayOpeningTime != null &&
          mondayClosingTime != null) {
        _profile.mondayOpeningHours = mondayOpeningTime;
        _profile.mondayClosingHours = mondayClosingTime;
      }
    }
    if (isTuesdayOpen != null) {
      _profile.isTuesdayOpen = isTuesdayOpen;
      if (isTuesdayOpen &&
          tuesdayOpeningTime != null &&
          tuesdayClosingTime != null) {
        _profile.tuesdayOpeningHours = tuesdayOpeningTime;
        _profile.tuesdayClosingHours = tuesdayClosingTime;
      }
    }
    if (isWednesdayOpen != null) {
      _profile.isWednesdayOpen = isWednesdayOpen;
      if (isWednesdayOpen &&
          wednesdayOpeningTime != null &&
          wednesdayClosingTime != null) {
        _profile.wednesdayOpeningHours = wednesdayOpeningTime;
        _profile.wednesdayClosingHours = wednesdayClosingTime;
      }
    }
    if (isThursdayOpen != null) {
      _profile.isThursdayOpen = isThursdayOpen;
      if (isThursdayOpen &&
          thursdayOpeningTime != null &&
          thursdayClosingTime != null) {
        _profile.thursdayOpeningHours = thursdayOpeningTime;
        _profile.thursdayClosingHours = thursdayClosingTime;
      }
    }
    if (isFridayOpen != null) {
      _profile.isFridayOpen = isFridayOpen;
      if (isFridayOpen &&
          fridayOpeningTime != null &&
          fridayClosingTime != null) {
        _profile.fridayOpeningHours = fridayOpeningTime;
        _profile.fridayClosingHours = fridayClosingTime;
      }
    }
    if (isSaturdayOpen != null) {
      _profile.isSaturdayOpen = isSaturdayOpen;
      if (isSaturdayOpen &&
          saturdayOpeningTime != null &&
          saturdayClosingTime != null) {
        _profile.saturdayOpeningHours = saturdayOpeningTime;
        _profile.saturdayClosingHours = saturdayClosingTime;
      }
    }
    if (isSundayOpen != null) {
      _profile.isSundayOpen = isSundayOpen;
      if (isSundayOpen &&
          sundayOpeningTime != null &&
          sundayClosingTime != null) {
        _profile.sundayOpeningHours = sundayOpeningTime;
        _profile.sundayClosingHours = sundayClosingTime;
      }
    }
    notifyListeners();
  }

  businessInfo({
    required String businessName,
    String? businessDescription,
    String? city,
    required String phoneNumber,
    String? locationDescription,
  }) {
    if (businessDescription != null) {
      _profile.businessDescription = businessDescription;
    }
    if (city != null) {
      _profile.city = city;
    }
    if (locationDescription != null) {
      _profile.locationDescription = locationDescription;
    }
    _profile.businessName = businessName;
    _profile.phoneNumber = phoneNumber;
    notifyListeners();
  }

  addBusinessProfilePhoto(File? photo) async {
    if (photo != null) {
      // Upload the photo & Get the image url
      String? _imageUrl = await uploadFile(photo);
      // Set the value
      _profile.businessProfilePhoto = _imageUrl;
    }
    notifyListeners();
  }

  deleteBusinessProfilePhoto() {
    _profile.businessProfilePhoto = null;
    notifyListeners();
  }

  addGpsLocation(double lat, double lon) {
    _profile.gpsLocation = GeoPoint(lat, lon);
    notifyListeners();
  }
}
