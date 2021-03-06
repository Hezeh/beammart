import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

clickstreamUtil({
  String? deviceId,
  String? itemId,
  String? merchantId,
  int? index,
  String? timeStamp,
  String? searchId,
  double? lat,
  double? lon,
  String? searchQuery,
  String? recsId,
  String? category,
  String? type,
}) async {
  // Make a http call to the backend
  final String _clickId = _uuid.v4();
  final Map<String, dynamic> _data = {
    'deviceId': deviceId,
    'itemId': itemId,
    'merchantId': merchantId,
    'index': index,
    'timeStamp': timeStamp,
    'searchId': searchId,
    'lat': lat,
    'lon': lon,
    'query': searchQuery,
    'recsId': recsId,
    'category': category,
    'type': type,
    'clickId': _clickId,
  };
  await http.post(
    Uri.https('clickstream.beammart.app', '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(_data),
  );
}