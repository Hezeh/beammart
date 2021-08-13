import 'package:beammart/models/item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumer_service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsumerServiceModel {
  String? itemId;
  String? userId;
  List<String>? images;
  String? title;
  String? description;
  int? price;
  Location? location;
  String? locationDescription;
  String? businessName;
  String? businessDescription;
  String? phoneNumber;
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
  double? distance;
  String? businessId;
  String? dateJoined;
  String? dateAdded;
  String? merchantPhotoUrl;
  bool? inStock;
  bool? isMondayOpen;
  bool? isTuesdayOpen;
  bool? isWednesdayOpen;
  bool? isThursdayOpen;
  bool? isFridayOpen;
  bool? isSaturdayOpen;
  bool? isSundayOpen;
  String? category;
  String? subCategory;

  ConsumerServiceModel({
    this.itemId,
    this.userId,
    this.images,
    this.title,
    this.description,
    this.price,
    this.location,
    this.locationDescription,
    this.businessName,
    this.businessDescription,
    this.phoneNumber,
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
    this.distance,
    this.businessId,
    this.dateJoined,
    this.dateAdded,
    this.merchantPhotoUrl,
    this.inStock,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.category,
    this.subCategory,
  });

  factory ConsumerServiceModel.fromJson(Map<String, dynamic>? json) =>
      _$ConsumerServiceModelFromJson(json!);
  Map<String, dynamic> toJson() => _$ConsumerServiceModelToJson(this);
}
