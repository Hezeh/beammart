import 'dart:convert';
import 'package:beammart/models/item_results.dart';
import 'package:beammart/models/suggestions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class SearchAPIWrapper {
  // Uri searchItemUri(String item) => Uri(
  //       scheme: 'http',
  //       host: '10.0.2.2',
  //       port: 8000,
  //       path: 'suggestions/',
  //       queryParameters: {
  //         'q': item,
  //         'country_code': 'ken',
  //         'language_code': 'en',
  //       },
  //     );
  Uri searchItemUri(String item) => Uri(
        scheme: 'https',
        host: 'api.beammart.app',
        // port: 8000,
        path: 'suggestions/',
        queryParameters: {
          'q': item,
          'country_code': 'ken',
          'language_code': 'en',
        },
      );

  Future<Suggestions> suggestItems(String item) async {
    // final uri = searchItemUri(item);
    final response = await http.get(
      Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'suggestions',
      queryParameters: {
        'q': item,
        'country_code': 'ken',
        'language_code': 'en'
      }
    ),
    );
    final _response = Suggestions.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return _response;
    }
    return Suggestions();
  }

  Future<ItemResults> searchItems(String searchQuery, LatLng location) async {
    final response = await http.get(
      Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'search', 
      queryParameters: {
        'q': searchQuery,
        'lat': location.latitude,
        'lon': location.longitude
      }
    ),
    );
    final jsonResponse = ItemResults.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return jsonResponse;
    }
    return ItemResults();
  }
}
