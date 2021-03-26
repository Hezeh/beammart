import 'dart:convert';

import 'package:beammart/models/item_recommendations.dart';
import 'package:http/http.dart' as http;

Future<ItemRecommendations> getRecs({double lat, double lon}) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'recs' 
    ),
  );
  final jsonResponse = ItemRecommendations.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ItemRecommendations();
}
