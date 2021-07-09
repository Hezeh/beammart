import 'dart:convert';

import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<ItemRecommendations> getRecs(BuildContext context,
    {double? lat, double? lon}) async {
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    final LatLng? _loc = Provider.of<LocationProvider>(context).currentLoc;

    if (_loc != null) {
      print("Location: ${_loc.latitude}, ${_loc.longitude}");
      print("Getting Recs");
      final response = await http.get(
        Uri(
            scheme: 'https',
            host: 'api.beammart.app',
            path: 'recs',
            query: 'lat=${_loc.latitude}&lon=${_loc.longitude}'),
      );
      final jsonResponse =
          ItemRecommendations.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        return jsonResponse;
      }
      return ItemRecommendations();
    } else {
      print("Get Recs");
      final response = await http.get(
        Uri(
          scheme: 'https',
          host: 'api.beammart.app',
          path: 'recs',
        ),
      );
      final jsonResponse =
          ItemRecommendations.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        return jsonResponse;
      }
      return ItemRecommendations();
    }
  } else {
    print("Fetching Web Recs");
    final url = Uri.parse('https://api.beammart.app/recs');
    print("Url: $url");
    final response = await http.get(url);
    print("Recs Response Code ${response.statusCode}");
    print("Fetched Recs");
    print("Response: $response");
    final jsonResponse =
        ItemRecommendations.fromJson(json.decode(response.body));
    print("Recs Response Code ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Have Web Recommendations");
      return jsonResponse;
    }
    return ItemRecommendations();
  }
}

Future<ItemRecommendations> getWebRecs(BuildContext context) async {
  print("Fetching Web Recs");
  final url = Uri.parse('https://api.beammart.app/recs');
  print("Url: $url");
  final response = await http.get(url);
  print("Recs Response Code ${response.statusCode}");
  print("Fetched Recs");
  print("Response: $response");
  final jsonResponse = ItemRecommendations.fromJson(json.decode(response.body));
  print("Recs Response Code ${response.statusCode}");
  if (response.statusCode == 200) {
    print("Have Web Recommendations");
    return jsonResponse;
  }
  return ItemRecommendations();
}
