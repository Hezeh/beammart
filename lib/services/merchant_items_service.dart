import 'dart:convert';

import 'package:beammart/models/category_items.dart';
import 'package:http/http.dart' as http;

Future<CategoryItems> getMerchantItems(String merchantId) async {
  final _url = 'https://api.beammart.app/merchant/$merchantId';
  final response = await http.get(_url);
  final jsonResponse = CategoryItems.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    print(jsonResponse);
    return jsonResponse;
  }
  return CategoryItems();
}
