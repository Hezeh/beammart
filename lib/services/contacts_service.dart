import 'dart:convert';

import 'package:beammart/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

Future<void> createContactList(String? userId, String? listName) async {
  final _docId = Uuid().v4();
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(_docId);
  final Map<String, dynamic> _docData = {
    'listName': listName,
    'contactListId': _docId,
  };
  await _dbRef.set(_docData, SetOptions(merge: true));
}

Future<void> deleteContactList() async {}

Future<void> editContactList() async {}

Future<void> deleteSingleContactInList() async {}

Future<void> addSingleContactToList(
  String? contactListId,
  String? userId,
  Contact? contact,
) async {
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(contactListId)
      .collection('contact')
      .doc(contact!.contactId);
  await _dbRef.set(contact.toJson(), SetOptions(merge: true));
}

Future<void> editSingleContactInList(
  String? contactListId,
  String? userId,
  Contact? contact,
) async {
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(contactListId)
      .collection('contact')
      .doc(contact!.contactId);
  await _dbRef.set(contact.toJson(), SetOptions(merge: true));
}

sendMerchantMarketingMessage({
  required String? message,
  required String? userId,
  required String? listId,
}) async {
  final Map<String, dynamic> _data = {
    'message': message,
    'userId': userId,
    'listId': listId,
  };
  await http.post(
    Uri.https('api.beammart.app', '/send-message'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(_data),
  );
}
