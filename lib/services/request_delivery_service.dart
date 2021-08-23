import 'dart:convert';
import 'package:beammart/models/consumer_address.dart';
import 'package:beammart/models/contact.dart';
import 'package:http/http.dart' as http;
import 'package:beammart/models/order.dart';
import 'package:beammart/models/profile.dart';

requestDelivery({
  required Order? order,
  required Profile? merchantProfile,
}) async {
  final Map<String, dynamic> _data = {
    "recepient": {
      "recipient_name":
          "${order!.customerContact!.firstName} ${order.customerContact!.lastName}",
      "recipient_phone": order.customerContact!.firstName,
      "recipient_email": order.customerContact!.firstName,
      "recipient_notes": "",
      "recipient_notify": true,
    },
    "merchant": {
      "sender_name": merchantProfile!.businessName,
      "sender_phone": merchantProfile.phoneNumber,
      "sender_email": merchantProfile.email,
      "sender_notes": "",
      "sender_notify": true
    },
    "customer_address": {
      "address_name": order.consumerAddress!.addressName,
      "address_lat": order.consumerAddress!.addressLat,
      "address_lon": order.consumerAddress!.addressLon,
      "address_description": order.consumerAddress!.addressDescription
    },
    "merchant_address": {
      "address_name": order.merchantAddress!.addressName,
      "address_lat": order.merchantAddress!.addressLat,
      "address_lon": order.merchantAddress!.addressLon,
      "address_description": order.merchantAddress!.addressDescription
    },
    "order_details": {
      "item_name": order.item!.title,
      "amount": order.totalOrderAmount.toString(),
      "pickup_date": DateTime.now(),
      "note": ""
    }
  };
  await http.post(
    Uri.https('api.beammart.app', '/get-rider'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(_data),
  );
}
