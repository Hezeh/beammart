import 'package:beammart/models/consumer_address.dart';
import 'package:beammart/models/delivery_driver.dart';
import 'package:beammart/models/item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  final String? orderId;
  final String? deliveryId;
  final Item? item;
  final bool? delivered;
  final String? deliveryEAT;
  final DeliveryDriver? deliveryDriver;
  final int? quantity;
  final double? totalOrderAmount;
  final ConsumerAddress? consumerAddress;
  final ConsumerAddress? merchantAddress;
  final bool? isPaymentMade;
  final bool? collectPaymentFromConsumer;
  final String? orderTimestamp;
  final String? deliveryTimestamp;
  final bool? accepted;

  Order({
    this.orderId,
    this.deliveryId,
    this.item,
    this.delivered = false,
    this.deliveryEAT,
    this.deliveryDriver,
    this.quantity,
    this.totalOrderAmount,
    this.consumerAddress,
    this.merchantAddress,
    this.isPaymentMade = false,
    this.collectPaymentFromConsumer = false,
    this.orderTimestamp,
    this.deliveryTimestamp,
    this.accepted
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
