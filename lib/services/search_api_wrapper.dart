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
    final url =
        "https://api.beammart.app/suggestions?q=$item&country_code=ken&language_code=en";
    final response = await http.get(url);
    // final _response = SearchResponse.fromJson(json.decode(response.body));
    final _response = Suggestions.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return _response;
    }
    print(response.statusCode);
    print(_response);
    // return SearchResponse();
    return Suggestions();
  }

  Future<ItemResults> searchItems(String searchQuery, LatLng location) async {
    // final LatLng location = LatLng(0.0, 0.0);
    final _url =
        'https://api.beammart.app/search?q=$searchQuery&lon=${location.longitude}&lat=${location.latitude}';
    final response = await http.get(_url);
    final jsonResponse = ItemResults.fromJson(json.decode(response.body));
    if (response.statusCode == 200) {
      return jsonResponse;
    }
    print(response.body);
    print(response.statusCode);
    return ItemResults();
  }
}
