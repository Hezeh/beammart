import 'dart:convert';

import 'package:beammart/models/click_analytics_data.dart';
import 'package:beammart/models/impressions_analytics_data.dart';
import 'package:http/http.dart' as http;

Future<ImpressionsAnalyticsData> getImpressionsAnalyticsData(
    String? merchantId) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'impressions/analytics/$merchantId',
    ),
  );
  final jsonResponse =
      ImpressionsAnalyticsData.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ImpressionsAnalyticsData();
}

Future<ClickAnalytics> getClicksAnalyticsData(String? merchantId) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'clicks/analytics/$merchantId',
    ),
  );
  final jsonResponse = ClickAnalytics.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ClickAnalytics();
}

Future<ImpressionsAnalyticsData> getItemImpressionsAnalyticsData(
    String itemId) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'item/impressions/analytics/$itemId',
    ),
  );
  final jsonResponse =
      ImpressionsAnalyticsData.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ImpressionsAnalyticsData();
}

Future<ClickAnalytics> getItemClicksAnalyticsData(String itemId) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'item/clicks/analytics/$itemId',
    ),
  );
  final jsonResponse = ClickAnalytics.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    return jsonResponse;
  }
  return ClickAnalytics();
}
