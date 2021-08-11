import 'package:json_annotation/json_annotation.dart';

part 'service_detail.g.dart';

@JsonSerializable()
class ServiceDetail {
  final String? serviceId;
  final String? serviceName;
  final String? serviceDescription;
  final double? servicePrice;
  final String? servicePriceType;

  ServiceDetail({
    this.serviceId,
    this.serviceName,
    this.serviceDescription,
    this.servicePrice,
    this.servicePriceType,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailToJson(this);
}
