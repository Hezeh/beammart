import 'package:beammart/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ContactInfoProvider with ChangeNotifier {
  Contact? _contact;
  final User? _user;

  ContactInfoProvider(this._user) {
    if (this._user != null) {
      getConsumerContactInfo(this._user);
    }
  }

  Contact? get contact => _contact;

  getConsumerContactInfo(User? _user) async {
    if (_user != null) {
      final _consumerDbRef = FirebaseFirestore.instance.collection('consumers');
      final DocumentSnapshot<Map<String, dynamic>> _consumerDoc =
          await _consumerDbRef.doc(_user.uid).get();
      if (_consumerDoc.exists) {
        _contact = Contact.fromJson(_consumerDoc['contactInfo']);
      }
      notifyListeners();
    }
  }
}
