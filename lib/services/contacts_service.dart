import 'package:beammart/models/contact.dart';
import 'package:beammart/models/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Future<List<Contact?>?> getContactsInList(
//     String? listId, String? userId) async {
//   final _dbRef = FirebaseFirestore.instance
//       .collection('all-contacts')
//       .doc(userId)
//       .collection('contact-list')
//       .doc(listId)
//       .collection('contacts');
//   final _snapshot = await _dbRef.get();

//   if (_snapshot.docs.isNotEmpty) {
//     List<Contact?>? _contacts = [];
//     _snapshot.docs.forEach((i) {
//       final _contactData = Contact.fromJson(i.data());
//       _contacts.add(_contactData);
//     });
//     return _contacts;
//   } else {
//     return null;
//   }
// }

Future<List<ContactList?>?> getContactsLists(String? userId) async {
  print("Getting Lists");
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list');
  final _snapshot = await _dbRef.get();

  if (_snapshot.docs.isNotEmpty) {
    List<ContactList> _contactLists = [];
    _snapshot.docs.forEach((i) {
      final _contactData = ContactList.fromJson(i.data());
      _contactLists.add(_contactData);
    });
    return _contactLists;
  } else {
    return null;
  }
}

Future<void> createContactList(String? userId, String? listName) async {
  final _docId = Uuid().v4();
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(_docId);
  final Map<String, dynamic> _docData = {
    'listName': listName,
    'contacts': [],
    'contactId': _docId,
  };
  await _dbRef.set(
    _docData,
    SetOptions(
      merge: true,
    ),
  );
  // print("${_newRef.path}");
}

Future<void> deleteContactList() async {}

Future<void> editContactList() async {}

Future<void> deleteSingleContactInList() async {}

Future<void> addSingleContactToList(
  String? docId,
  String? userId,
  Contact? contact,
) async {
  print("Doc Id : $docId");
  final List<dynamic> _contacts = [];
  _contacts.add(contact!.toJson());
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(docId);
  await _dbRef.set(
    {
      'contacts': FieldValue.arrayUnion(_contacts),
    },
    SetOptions(merge: true),
  );
}

Future<void> editSingleContactInList(
  String? docId,
  String? userId,
  Contact? contact,
) async {
  final List<dynamic> _contacts = [];
  _contacts.add(contact);
  final _dbRef = FirebaseFirestore.instance
      .collection('contacts')
      .doc(userId)
      .collection('contact-list')
      .doc(docId);
  await _dbRef.set(
    {
      'contacts': FieldValue.arrayRemove(_contacts),
    },
    SetOptions(merge: true),
  );
  await _dbRef.set(
    {
      'contacts': FieldValue.arrayUnion(_contacts),
    },
    SetOptions(merge: true),
  );
}
