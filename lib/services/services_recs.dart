import 'dart:convert';

import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<ItemRecommendations> getRecs(BuildContext context,
    {double? lat, double? lon}) async {
  final LatLng? _loc = Provider.of<LocationProvider>(context).currentLoc;
  if (_loc != null) {
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
}
