import 'package:json_annotation/json_annotation.dart';

part 'delivery_driver.g.dart';

@JsonSerializable(explicitToJson: true)
class DeliveryDriver {
  final String? driverId;
  final String? driverName;
  final String? driverPhotoUrl;
  final String? driverPhoneNumber;

  DeliveryDriver({
    this.driverId,
    this.driverName,
    this.driverPhotoUrl,
    this.driverPhoneNumber,
  });

  factory DeliveryDriver.fromJson(Map<String, dynamic> json) => _$DeliveryDriverFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryDriverToJson(this);
}
