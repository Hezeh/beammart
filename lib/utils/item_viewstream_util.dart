import 'package:http/http.dart' as http;
import 'dart:convert';

onItemStartView({
  String? itemId,
  String? timeStamp,
  String? deviceId,
  String? viewId,
  double? percentage,
  String? merchantId,
  String? query,
}) async {
  print("Started at: $itemId and Percentage $percentage");
  final postResponse = await http.post(
    Uri.https('viewstream.beammart.app', '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String?>{
        'deviceId': deviceId,
        'timestamp': timeStamp,
        'itemId': itemId,
        'viewId': viewId,
        'merchantId': merchantId,
        'searchQuery': query
      },
    ),
  );
  print(postResponse.statusCode);
  print(merchantId);
}
