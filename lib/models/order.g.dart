// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
    orderId: json['orderId'] as String?,
    deliveryId: json['deliveryId'] as String?,
    item: json['item'] == null
        ? null
        : Item.fromJson(json['item'] as Map<String, dynamic>),
    delivered: json['delivered'] as bool?,
    deliveryEAT: json['deliveryEAT'] as String?,
    deliveryDriver: json['deliveryDriver'] == null
        ? null
        : DeliveryDriver.fromJson(
            json['deliveryDriver'] as Map<String, dynamic>),
    quantity: json['quantity'] as int?,
    totalOrderAmount: (json['totalOrderAmount'] as num?)?.toDouble(),
    consumerAddress: json['consumerAddress'] == null
        ? null
        : ConsumerAddress.fromJson(
            json['consumerAddress'] as Map<String, dynamic>),
    merchantAddress: json['merchantAddress'] == null
        ? null
        : ConsumerAddress.fromJson(
            json['merchantAddress'] as Map<String, dynamic>),
    isPaymentMade: json['isPaymentMade'] as bool?,
    collectPaymentFromConsumer: json['collectPaymentFromConsumer'] as bool?,
    orderTimestamp: json['orderTimestamp'] as String?,
    deliveryTimestamp: json['deliveryTimestamp'] as String?,
  );
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'deliveryId': instance.deliveryId,
      'item': instance.item?.toJson(),
      'delivered': instance.delivered,
      'deliveryEAT': instance.deliveryEAT,
      'deliveryDriver': instance.deliveryDriver?.toJson(),
      'quantity': instance.quantity,
      'totalOrderAmount': instance.totalOrderAmount,
      'consumerAddress': instance.consumerAddress?.toJson(),
      'merchantAddress': instance.merchantAddress?.toJson(),
      'isPaymentMade': instance.isPaymentMade,
      'collectPaymentFromConsumer': instance.collectPaymentFromConsumer,
      'orderTimestamp': instance.orderTimestamp,
      'deliveryTimestamp': instance.deliveryTimestamp,
    };
