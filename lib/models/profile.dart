import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String? city;
  String? locationDescription;
  @JsonKey(fromJson: _fromJsonGeoPoint, toJson: _toJsonGeoPoint)
  GeoPoint? gpsLocation;

  static GeoPoint? _fromJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }

  static GeoPoint? _toJsonGeoPoint(GeoPoint? geoPoint) {
    return geoPoint;
  }

  String? storeId;
  String? businessName;
  String? phoneNumber;
  String? businessDescription;
  String? mondayOpeningHours;
  String? mondayClosingHours;
  String? tuesdayOpeningHours;
  String? tuesdayClosingHours;
  String? wednesdayOpeningHours;
  String? wednesdayClosingHours;
  String? thursdayOpeningHours;
  String? thursdayClosingHours;
  String? fridayOpeningHours;
  String? fridayClosingHours;
  String? saturdayOpeningHours;
  String? saturdayClosingHours;
  String? sundayOpeningHours;
  String? sundayClosingHours;
  String? userId;
  bool? isMondayOpen;
  bool? isTuesdayOpen;
  bool? isWednesdayOpen;
  bool? isThursdayOpen;
  bool? isFridayOpen;
  bool? isSaturdayOpen;
  bool? isSundayOpen;
  String? businessProfilePhoto;
  double? tokensBalance;
  double? tokensInUse;
  String? email;
  bool? emailVerified;
  String? displayName;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;

  Profile(
      {this.userId,
      this.storeId,
      this.businessName,
      this.phoneNumber,
      this.businessDescription,
      this.mondayOpeningHours,
      this.mondayClosingHours,
      this.tuesdayOpeningHours,
      this.tuesdayClosingHours,
      this.wednesdayOpeningHours,
      this.wednesdayClosingHours,
      this.thursdayOpeningHours,
      this.thursdayClosingHours,
      this.fridayOpeningHours,
      this.fridayClosingHours,
      this.saturdayOpeningHours,
      this.saturdayClosingHours,
      this.sundayOpeningHours,
      this.sundayClosingHours,
      this.city,
      this.locationDescription,
      this.gpsLocation,
      this.isMondayOpen,
      this.isTuesdayOpen,
      this.isWednesdayOpen,
      this.isThursdayOpen,
      this.isFridayOpen,
      this.isSaturdayOpen,
      this.isSundayOpen,
      this.businessProfilePhoto,
      this.tokensBalance,
      this.tokensInUse,
      this.email,
      this.emailVerified,
      this.creationTime,
      this.lastSignInTime,
      this.displayName,
      this.photoUrl});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
