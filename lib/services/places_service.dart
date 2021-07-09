import 'package:beammart/models/place.dart';
import 'package:beammart/models/place_search.dart';
import 'package:beammart/utils/secrets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = Secrets.API_KEY;

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    Uri _uri = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: 'maps/api/place/autocomplete/json',
      query: 'input=$search&key=$key',
    );
    // var url =
    //     'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$key';
    var response = await http.get(_uri);
    var json = convert.jsonDecode(response.body);
    // print("Json: $json");
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    Uri _uri = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: 'maps/api/place/details/json',
      query: 'place_id=$placeId&key=$key',
    );
    // var url =
    //     'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(_uri);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    Uri _uri = Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      path: 'maps/api/place/textsearch/json',
      query: 'location=$lat,$lng&type=$placeType&rankby=distance&key=$key',
    );
    // var url =
    //     'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$key';
    var response = await http.get(_uri);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
