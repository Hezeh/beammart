import 'package:beammart/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Order>> getUserOrders(String? userId) {
  final _collectionRef = FirebaseFirestore.instance
      .collection('consumers')
      .doc(userId)
      .collection('orders');

  final _docs = _collectionRef
      .orderBy(
        'orderTimestamp',
        descending: true,
      )
      .snapshots();

  return _docs.map(
    (snapshot) => snapshot.docs
        .map(
          (e) => Order.fromJson(
            e.data(),
          ),
        )
        .toList(),
  );
}
