// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryDriver _$DeliveryDriverFromJson(Map<String, dynamic> json) {
  return DeliveryDriver(
    driverId: json['driverId'] as String?,
    driverName: json['driverName'] as String?,
    driverPhotoUrl: json['driverPhotoUrl'] as String?,
    driverPhoneNumber: json['driverPhoneNumber'] as String?,
  );
}

Map<String, dynamic> _$DeliveryDriverToJson(DeliveryDriver instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'driverName': instance.driverName,
      'driverPhotoUrl': instance.driverPhotoUrl,
      'driverPhoneNumber': instance.driverPhoneNumber,
    };
