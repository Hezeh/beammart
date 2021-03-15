import 'dart:convert';

import 'package:beammart/models/item_recommendations.dart';
import 'package:http/http.dart' as http;

Future<ItemRecommendations> getRecs() async {
  final _url = 'https://api.beammart.app/recs';
  final response = await http.get(_url);
  final jsonResponse = ItemRecommendations.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ItemRecommendations();
}
