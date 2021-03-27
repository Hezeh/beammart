import 'dart:convert';

import 'package:beammart/models/category_items.dart';
import 'package:http/http.dart' as http;

Future<CategoryItems> getMerchantItems(String? merchantId) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'merchant/$merchantId'
    ),
  );
  final jsonResponse = CategoryItems.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    print(jsonResponse);
    return jsonResponse;
  }
  return CategoryItems();
}
