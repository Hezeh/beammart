import 'package:beammart/models/item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumer_service_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsumerServiceModel {
  String? serviceId;
  String? serviceName;
  String? serviceDescription;
  double? servicePrice;
  String? servicePriceType;
  String? userId;
  bool? isServiceBusiness;
  String? businessServiceCategory;
  String? businessServiceId;
  List<String>? images;
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
    this.userId,
    this.images,
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
    this.businessServiceCategory,
    this.businessServiceId,
    this.isServiceBusiness,
    this.serviceDescription,
    this.serviceId,
    this.serviceName,
    this.servicePrice,
    this.servicePriceType,
  });

  factory ConsumerServiceModel.fromJson(Map<String, dynamic>? json) =>
      _$ConsumerServiceModelFromJson(json!);
  Map<String, dynamic> toJson() => _$ConsumerServiceModelToJson(this);
}
