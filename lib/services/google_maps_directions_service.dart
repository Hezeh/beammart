import 'dart:convert';

import 'package:beammart/models/google_maps_directions.dart';
import 'package:beammart/utils/secrets.dart';
import 'package:http/http.dart' as http;

Future<GoogleMapsDirections> googleMapsDirectionsService(
  double startLat,
  double startLon,
  double destinationLat,
  double destinationLon,
) async {
  final _url = Uri.https(
    'maps.googleapis.com',
    '/maps/api/directions/json',
    {
      'origin': '$startLat,$startLon',
      'destination': '$destinationLat,$destinationLon',
      'key': '${Secrets.API_KEY}',
    },
  );
  var _response = await http.get(_url);

  if (_response.statusCode == 200) {
    final jsonBody = json.decode(_response.body);
    final GoogleMapsDirections jsonResponse =
        GoogleMapsDirections.fromJson(jsonBody);
    return jsonResponse;
  }
  return GoogleMapsDirections();
}
