import 'dart:convert';

import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<ItemRecommendations> getRecs(BuildContext context,
    {double? lat, double? lon}) async {
  // final _loc = Provider.of<LatLng?>(context, listen: false);
  // print("Started");
  // final _locData =
  //     await Provider.of<LocationProvider>(context).location.getLocation();
  // final _loc =
  //     LatLng(_locData.latitude as double, _locData.longitude as double);
  final LatLng? _loc = Provider.of<LocationProvider>(context).currentLoc;
  

  // if (lat != null && lon != null) {
  //   final response = await http.get(
  //     Uri(
  //       scheme: 'https',
  //       host: 'api.beammart.app',
  //       path: 'recs',
  //       query: 'lat=$lat&lon=$lon'
  //     ),
  //   );
  //   final jsonResponse =
  //       ItemRecommendations.fromJson(json.decode(response.body));
  //   if (response.statusCode == 200) {
  //     return jsonResponse;
  //   }
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
}
