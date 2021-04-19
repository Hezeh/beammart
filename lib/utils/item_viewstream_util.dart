import 'package:http/http.dart' as http;
import 'dart:convert';

onItemView({
  String? itemId,
  String? timeStamp,
  String? deviceId,
  String? viewId,
  double? percentage,
  String? merchantId,
  String? query,
  double? lat,
  double? lon,
  int? index,
  String? type
}) async {
  print("Started at: $itemId and Percentage $percentage");
  final postResponse = await http.post(
    Uri.https('viewstream.beammart.app', '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic?>{
        'deviceId': deviceId,
        'timestamp': timeStamp,
        'itemId': itemId,
        'viewId': viewId,
        'merchantId': merchantId,
        'searchQuery': query,
        'lat': lat,
        'lon': lon,
        'index': index,
        'type': type,
      },
    ),
  );
  print(postResponse.statusCode);
  print(merchantId);
}
