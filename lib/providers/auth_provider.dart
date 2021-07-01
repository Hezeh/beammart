import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
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

  loginFacebook() async {
    print('Starting Facebook Login');
    final fb = FacebookLogin();

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        print('It worked');

        //Get Token
        final FacebookAccessToken? fbToken = res.accessToken;

        //Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken!.token);

        //User Credential to Sign in with Firebase
        final UserCredential result =
            await firebaseAuth.signInWithCredential(credential);

        print('${result.user!.displayName} is now logged in');

        break;
      case FacebookLoginStatus.cancel:
        print('The user canceled the login');
        break;
      case FacebookLoginStatus.error:
        print('There was an error');
        break;
    }
  }

  signInWithEmailPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _loading = false;
      notifyListeners();
      return 'Successful SignIn';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        _loading = false;
        notifyListeners();
        return 'invalid-email';
      } else if (e.code == 'user-disabled') {
        _loading = false;
        notifyListeners();
        return 'user-disabled';
      } else if (e.code == 'user-not-found') {
        _loading = false;
        notifyListeners();
        return 'user-not-found';
      } else if (e.code == 'wrong-password') {
        _loading = false;
        notifyListeners();
        return 'wrong-password';
      }
    } catch (e) {
      print(e);
    }
    _loading = false;
    notifyListeners();
  }

  createUserWithEmailPassword(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _loading = false;
      notifyListeners();
      return "Successful SignUp";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _loading = false;
        notifyListeners();
        return "weak-password";
      } else if (e.code == 'email-already-in-use') {
        _loading = false;
        notifyListeners();
        return 'email-already-in-use';
      } else if (e.code == 'invalid-email') {
        _loading = false;
        notifyListeners();
        return 'invalid-email';
      } else if (e.code == 'operation-not-allowed') {
        _loading = false;
        notifyListeners();
        return 'operation-not-allowed';
      }
    } catch (e) {
      print("Error $e");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    // try {
    //   final GoogleSignIn _googleSignIn = GoogleSignIn();
    //   await _googleSignIn.disconnect();
    // } 
    // // } catch (e) {
    // //   print("Google Sign In Error: $e");
    // // } finally {
    // //   print("Finally block");
    // // }
    // try {
    //   final _fb = FacebookLogin();
    //   await _fb.logOut();
    // } catch (e) {
    //   print("Google Sign Out Error: $e");
    // }
    // print("Disconecting");
    _loading = null;
    notifyListeners();
    await FirebaseAuth.instance.signOut();
  }
}
