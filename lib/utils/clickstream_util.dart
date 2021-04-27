import 'dart:convert';
import 'package:http/http.dart' as http;

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
  };
  await http.post(
    Uri.https('clickstream.beammart.app', '/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(_data),
  );
}

// // SERP Clickstream
// searchEngineResultPageDetailClick(
//   String? deviceId,
//   String? itemId,
//   String? merchantId,
//   int? index,
//   String timeStamp,
//   String? searchId,
//   double lat,
//   double lon,
//   String? searchQuery
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'itemId': itemId,
//     'merchantId': merchantId,
//     'index': index,
//     'timeStamp': timeStamp,
//     'searchId': searchId,
//     'lat': lat,
//     'lon': lon,
//     'query': searchQuery,
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/serp'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Merchant Profile clickstream
// merchantProfileClickstream(
//   String? deviceId,
//   String? merchantId,
//   String timeStamp,
//   double lat,
//   double lon,
// ) async {
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'merchantId': merchantId,
//     'timeStamp': timeStamp,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/profile'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Recommendations page Item Clickstream
// recommendationsItemClickstream(
//     String? deviceId,
//     String? itemId,
//     String? merchantId,
//     int index,
//     String timeStamp,
//     String? category,
//     double lat,
//     double lon,
//     String? recsId) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'itemId': itemId,
//     'merchantId': merchantId,
//     'index': index,
//     'timeStamp': timeStamp,
//     'category': category,
//     'recsId': recsId,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/recs'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Category Item page Clickstream
// categoryItemClickstream(
//   String? deviceId,
//   String? itemId,
//   String? merchantId,
//   int index,
//   String timeStamp,
//   String? category,
//   double lat,
//   double lon,
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'itemId': itemId,
//     'merchantId': merchantId,
//     'index': index,
//     'timeStamp': timeStamp,
//     'category': category,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/category-item'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Category view all Clickstream
// categoryViewAllClickstream(
//   String? deviceId,
//   int index,
//   String timeStamp,
//   String? category,
//   double lat,
//   double lon,
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'index': index,
//     'timeStamp': timeStamp,
//     'category': category,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/category-all'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Merchant Profile product clickstream
// merchantProfileItemClickstream(
//   String? deviceId,
//   String? itemId,
//   String? merchantId,
//   int index,
//   String timeStamp,
//   double lat,
//   double lon,
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'itemId': itemId,
//     'merchantId': merchantId,
//     'index': index,
//     'timeStamp': timeStamp,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/profile-item'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Product Detail Phone Button Clickstream
// productPagePhoneCallClickstream(
//   String? deviceId,
//   String? itemId,
//   String? merchantId,
//   String timeStamp,
//   double lat,
//   double lon,
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'itemId': itemId,
//     'merchantId': merchantId,
//     'timeStamp': timeStamp,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/product-call'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }

// // Merchant Page Phone Button Clickstream
// merchantPagePhoneCallClickstream(
//   String deviceId,
//   String merchantId,
//   String timeStamp,
//   double lat,
//   double lon,
// ) async {
//   // Make a http call to the backend
//   final Map<String, dynamic> _data = {
//     'deviceId': deviceId,
//     'merchantId': merchantId,
//     'timeStamp': timeStamp,
//     'lat': lat,
//     'lon': lon
//   };
//   await http.post(
//     Uri.https('clickstream.beammart.app', '/profile-call'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(_data),
//   );
// }
