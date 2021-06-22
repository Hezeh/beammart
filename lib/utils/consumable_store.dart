import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _currentUser = FirebaseAuth.instance.currentUser;
final _db =
    FirebaseFirestore.instance.collection('profile').doc(_currentUser!.uid);

/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class ConsumableStore {
  // static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id, double tokens, String userId) {
    _writes = _writes.then((void _) => _doSave(tokens));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(double tokens, String userId) {
    _writes = _writes.then((void _) => _doConsume(tokens));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<dynamic> load() async {
    final _currentDoc = await _db.get();
    final _data = _currentDoc.data();
    final dynamic _tokensBalance = _data!['tokensBalance'];
    return _tokensBalance;
  }

  static Future<void> _doSave(double tokens) async {
    // int currentBalance = await load();
    dynamic currentBalance = await load();
    final dynamic newTokensBalance = currentBalance + tokens;
    await _db.set(
      {
        'tokensBalance': newTokensBalance,
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> _doConsume(dynamic tokens) async {
    dynamic currentBalance = await load();
    final dynamic newTokensBalance = currentBalance - tokens;
    await _db.set(
      {
        'tokensBalance': newTokensBalance,
      },
      SetOptions(merge: true),
    );
  }
}
