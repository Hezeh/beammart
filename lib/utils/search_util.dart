import 'package:beammart/screens/search_delegate.dart';
import 'package:flutter/material.dart';
import '../screens/search.dart' as customSearch;

void searchUtil(BuildContext context) async {
  await customSearch.showSearch(
    context: context,
    delegate: SearchScreen(),
  );
}
