import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkBalance(String userId, double requiredTokens) async =>
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final currentBalance = documentSnapshot.data()!['tokensBalance'];
        print(currentBalance);
        if (currentBalance >= requiredTokens) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    });
