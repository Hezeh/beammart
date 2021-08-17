// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceDetail _$ServiceDetailFromJson(Map<String, dynamic> json) =>
    ServiceDetail(
      serviceId: json['serviceId'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceDescription: json['serviceDescription'] as String?,
      servicePrice: (json['servicePrice'] as num?)?.toDouble(),
      servicePriceType: json['servicePriceType'] as String?,
    );

Map<String, dynamic> _$ServiceDetailToJson(ServiceDetail instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'serviceDescription': instance.serviceDescription,
      'servicePrice': instance.servicePrice,
      'servicePriceType': instance.servicePriceType,
    };
