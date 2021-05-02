import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier {
  // FirebaseAuth instance;
  final FirebaseAuth firebaseAuth;
  final CollectionReference _db =
      FirebaseFirestore.instance.collection('consumers');
  bool? _loading = true;

  AuthenticationProvider(this.firebaseAuth);

  // AuthenticationProvider(this.firebaseAuth) {
  // }

  // Using Stream to listen to Authentication State;
  Stream<User?> get authState => firebaseAuth.authStateChanges();
  User? get user => firebaseAuth.currentUser;
  bool? get loading => _loading;

  bool? get loadingAuth => _loading;

  signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleSignIn.clientId != null) {
      googleSignIn.signInSilently();
      _loading = false;
      notifyListeners();
    }

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        await firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        if (firebaseAuth.currentUser != null) {
          final String _userId = firebaseAuth.currentUser!.uid;
          print("User Id: $_userId");
          final DocumentSnapshot _doc = await _db.doc(_userId).get();
          if (!_doc.exists) {
            _db.doc(_userId).set(
              {
                'email': firebaseAuth.currentUser!.email,
                'displayName': firebaseAuth.currentUser!.displayName,
                'photoUrl': firebaseAuth.currentUser!.photoURL,
                'id': firebaseAuth.currentUser!.uid,
              },
              SetOptions(merge: true),
            );
          }
        }
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    // _profile = null;
    _loading = null;
    notifyListeners();
    return firebaseAuth.signOut();
  }
}
