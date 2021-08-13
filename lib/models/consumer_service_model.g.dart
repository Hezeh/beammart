// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumerServiceModel _$ConsumerServiceModelFromJson(Map<String, dynamic> json) {
  return ConsumerServiceModel(
    itemId: json['itemId'] as String?,
    userId: json['userId'] as String?,
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    title: json['title'] as String?,
    description: json['description'] as String?,
    price: json['price'] as int?,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    locationDescription: json['locationDescription'] as String?,
    businessName: json['businessName'] as String?,
    businessDescription: json['businessDescription'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    mondayOpeningHours: json['mondayOpeningHours'] as String?,
    mondayClosingHours: json['mondayClosingHours'] as String?,
    tuesdayOpeningHours: json['tuesdayOpeningHours'] as String?,
    tuesdayClosingHours: json['tuesdayClosingHours'] as String?,
    wednesdayOpeningHours: json['wednesdayOpeningHours'] as String?,
    wednesdayClosingHours: json['wednesdayClosingHours'] as String?,
    thursdayOpeningHours: json['thursdayOpeningHours'] as String?,
    thursdayClosingHours: json['thursdayClosingHours'] as String?,
    fridayOpeningHours: json['fridayOpeningHours'] as String?,
    fridayClosingHours: json['fridayClosingHours'] as String?,
    saturdayOpeningHours: json['saturdayOpeningHours'] as String?,
    saturdayClosingHours: json['saturdayClosingHours'] as String?,
    sundayOpeningHours: json['sundayOpeningHours'] as String?,
    sundayClosingHours: json['sundayClosingHours'] as String?,
    distance: (json['distance'] as num?)?.toDouble(),
    businessId: json['businessId'] as String?,
    dateJoined: json['dateJoined'] as String?,
    dateAdded: json['dateAdded'] as String?,
    merchantPhotoUrl: json['merchantPhotoUrl'] as String?,
    inStock: json['inStock'] as bool?,
    isMondayOpen: json['isMondayOpen'] as bool?,
    isTuesdayOpen: json['isTuesdayOpen'] as bool?,
    isWednesdayOpen: json['isWednesdayOpen'] as bool?,
    isThursdayOpen: json['isThursdayOpen'] as bool?,
    isFridayOpen: json['isFridayOpen'] as bool?,
    isSaturdayOpen: json['isSaturdayOpen'] as bool?,
    isSundayOpen: json['isSundayOpen'] as bool?,
    category: json['category'] as String?,
    subCategory: json['subCategory'] as String?,
  );
}

Map<String, dynamic> _$ConsumerServiceModelToJson(
        ConsumerServiceModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'userId': instance.userId,
      'images': instance.images,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'location': instance.location?.toJson(),
      'locationDescription': instance.locationDescription,
      'businessName': instance.businessName,
      'businessDescription': instance.businessDescription,
      'phoneNumber': instance.phoneNumber,
      'mondayOpeningHours': instance.mondayOpeningHours,
      'mondayClosingHours': instance.mondayClosingHours,
      'tuesdayOpeningHours': instance.tuesdayOpeningHours,
      'tuesdayClosingHours': instance.tuesdayClosingHours,
      'wednesdayOpeningHours': instance.wednesdayOpeningHours,
      'wednesdayClosingHours': instance.wednesdayClosingHours,
      'thursdayOpeningHours': instance.thursdayOpeningHours,
      'thursdayClosingHours': instance.thursdayClosingHours,
      'fridayOpeningHours': instance.fridayOpeningHours,
      'fridayClosingHours': instance.fridayClosingHours,
      'saturdayOpeningHours': instance.saturdayOpeningHours,
      'saturdayClosingHours': instance.saturdayClosingHours,
      'sundayOpeningHours': instance.sundayOpeningHours,
      'sundayClosingHours': instance.sundayClosingHours,
      'distance': instance.distance,
      'businessId': instance.businessId,
      'dateJoined': instance.dateJoined,
      'dateAdded': instance.dateAdded,
      'merchantPhotoUrl': instance.merchantPhotoUrl,
      'inStock': instance.inStock,
      'isMondayOpen': instance.isMondayOpen,
      'isTuesdayOpen': instance.isTuesdayOpen,
      'isWednesdayOpen': instance.isWednesdayOpen,
      'isThursdayOpen': instance.isThursdayOpen,
      'isFridayOpen': instance.isFridayOpen,
      'isSaturdayOpen': instance.isSaturdayOpen,
      'isSundayOpen': instance.isSundayOpen,
      'category': instance.category,
      'subCategory': instance.subCategory,
    };
