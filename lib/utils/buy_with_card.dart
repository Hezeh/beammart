import 'package:beammart/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(_url) async => await canLaunch(_url)
    ? await launch(
        _url,
        enableJavaScript: true,
        forceWebView: true,
      )
    : throw 'Could not launch $_url';

Future buyWithCard(
  BuildContext context,
  double amount, {
  String? paymentOption,
}) async {
  final _profile = Provider.of<ProfileProvider>(context, listen: false).profile;
  final response = await http.post(
    Uri(
      scheme: 'https',
      host: 'api.beammart.app',
      path: 'pay',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "payment_options": "card",
      "amount": amount,
      "customer_info": {
        "id": "${_profile!.userId}",
        "email": "${_profile.email}",
        "phonenumber": "${_profile.phoneNumber}",
        "name": "${_profile.businessName}"
      }
    }),
  );
  final jsonResponse = Map<String, dynamic>.from(json.decode(response.body));
  if (response.statusCode == 200) {
    if (jsonResponse['status'] == 'success') {
      final _url = jsonResponse['data']['link'];
      _launchURL(_url);
      return "Success";
    } else {
      return "Transaction Failed";
    }
  } else {
    print(response.statusCode);
    print(json.decode(response.body));
    return "Could not complete request";
  }
}
