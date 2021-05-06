import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

Future<void> postPastSearches({
  String? deviceId,
  String? userId,
  String? query,
  double? lat,
  double? lon,
}) async {
  final String _eventId = _uuid.v4();
  final Map<String, dynamic> _data = {
    'deviceId': deviceId,
    'userId': userId,
    'query': query,
    'lat': lat,
    'lon': lon,
  };
  await http.post(
    Uri.https('api.beammart.app', '/searches'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(_data),
  );
}
