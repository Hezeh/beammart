import 'dart:convert';

import 'package:beammart/models/category_items.dart';
import 'package:http/http.dart' as http;

Future<CategoryItems> getCategoryItems(String categoryName) async {
  final _url = 'https://api.beammart.app/category/$categoryName';
  final response = await http.get(_url);
  final jsonResponse = CategoryItems.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return CategoryItems();
}
