import 'package:beammart/models/category_tokens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryTokensProvider with ChangeNotifier {
  CategoryTokens? _categoryTokens;

  CategoryTokens? get categoryTokens => _categoryTokens;

  // fetch and update from Firebase
  fetchTokenValues() async {
    final _doc = await FirebaseFirestore.instance
        .collection('tokens')
        .doc('categories')
        .get();
    final _data = CategoryTokens.fromJson(_doc.data());
    print(_data);
    _categoryTokens = _data;
    notifyListeners();
  }
}
