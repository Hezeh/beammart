import 'package:beammart/models/service_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

createNewBusinessService({
  required String? serviceName,
  required String? serviceDescription,
  required double? servicePrice,
  required String? servicePriceType,
  required String? userId,
}) async {
  final _serviceId = Uuid().v4();
  final _dbRef = FirebaseFirestore.instance
      .collection('profile')
      .doc(userId)
      .collection('services');

  final _data = ServiceDetail(
          serviceName: serviceName,
          serviceId: _serviceId,
          serviceDescription: serviceDescription,
          servicePrice: servicePrice,
          servicePriceType: servicePriceType)
      .toJson();

  await _dbRef.doc().set(
        _data,
        SetOptions(merge: true),
      );
}
