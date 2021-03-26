import 'dart:convert';

import 'package:beammart/models/category_items.dart';
import 'package:http/http.dart' as http;

Future<CategoryItems> getCategoryItems(String categoryName) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'category/$categoryName' 
    ),
  );
  final jsonResponse = CategoryItems.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return CategoryItems();
}
