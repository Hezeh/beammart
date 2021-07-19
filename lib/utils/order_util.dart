import 'package:beammart/models/consumer_address.dart';
import 'package:beammart/models/item.dart';
import 'package:beammart/models/order.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

createOrder(
  BuildContext context, {
  Item? item,
  int? itemQuantity,
  ConsumerAddress? consumerAddress,
  double? totalOrderAmount,
}) async {
  final _orderId = Uuid().v4();
  final _deliveryId = Uuid().v4();
  final _orderTimestamp = DateTime.now().toIso8601String();
  final _userProvider = Provider.of<AuthenticationProvider>(context, listen: false);
  final _collectionRef = FirebaseFirestore.instance
      .collection('consumers')
      .doc(_userProvider.user!.uid)
      .collection('orders');
  final _data = Order(
    item: item,
    quantity: itemQuantity,
    collectPaymentFromConsumer: false,
    consumerAddress: consumerAddress,
    totalOrderAmount: totalOrderAmount,
    delivered: false,
    deliveryDriver: null,
    isPaymentMade: false,
    orderId: _orderId,
    deliveryEAT: null,
    deliveryId: _deliveryId,
    merchantAddress: null,
    deliveryTimestamp: null,
    orderTimestamp: _orderTimestamp,
  ).toJson();
  await _collectionRef.doc(_orderId).set(
        _data,
        SetOptions(merge: true),
      );
}
