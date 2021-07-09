import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot<Map<String, dynamic>>> tokensPricing() async {
  final _tokensPricingRef =
      FirebaseFirestore.instance.collection('tokensPricing');
  final _prices = await _tokensPricingRef.orderBy('tokens').get();
  return _prices;
}
