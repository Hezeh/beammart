import 'dart:io';
import 'package:beammart/screens/merchants/merchants_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

// Future<String> uploadFiles(File _image) async {
//   firebase_storage.Reference storageReference = firebase_storage
//       .FirebaseStorage.instance
//       .ref()
//       .child('items/${basename(_image.path)}');
//   firebase_storage.UploadTask task = storageReference.putFile(_image);

//   return await task.snapshot.ref.getDownloadURL();
// }

Future<String?> uploadFile(File _image) async {
  firebase_storage.Reference storageReference = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child('items/${basename(_image.path)}');
  firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);

  String? returnUrl;
  await uploadTask.whenComplete(() async {
    await storageReference.getDownloadURL().then((fileUrl) => {
          print(fileUrl),
          returnUrl = fileUrl,
        });
  });

  return returnUrl;
}

// updateData(BuildContext context, Map<String, dynamic> data, String id, String userId) {

//   final DocumentReference _itemsRef =
//       FirebaseFirestore.instance.collection('profiles').doc(userId).collection('items').doc(id);
//   _itemsRef.set(data, SetOptions(merge: true)).then(
//         (value) => Navigator.popUntil(
//           context,
//           ModalRoute.withName('/'),
//         ),
//       );
// }

saveItemFirestore(
    BuildContext context, String _userId, Map<String, dynamic> data) {
  final _uuid = Uuid().v4();
  final DocumentReference _itemsRef = FirebaseFirestore.instance
      .collection('profile')
      .doc(_userId)
      .collection('items')
      .doc(_uuid);

  _itemsRef.set({
    ...data,
  }, SetOptions(merge: true)).then((value) {
    // Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MerchantHomeScreen(),
      ),
      ModalRoute.withName('/'),
    );
  });
}
