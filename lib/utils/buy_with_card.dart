import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'dart:core';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

// void _launchURL(_url) async => await canLaunch(_url)
//     ? await launch(
//         _url,
//         enableJavaScript: true,
//         forceWebView: true,
//       )
//     : throw 'Could not launch $_url';

void _launchURL(dynamic url, BuildContext context) async {
  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
        // // or user defined animation.
        // animation: const CustomTabsSystemAnimation(
        //   startEnter: 'slide_up',
        //   startExit: 'android:anim/fade_out',
        //   endEnter: 'android:anim/fade_in',
        //   endExit: 'slide_down',
        // ),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

Future buyWithCard(
  BuildContext context,
  double amount, {
  String? paymentOption,
}) async {
  // final _profile = Provider.of<ProfileProvider>(context, listen: false).profile;
  final _authProvider =
      Provider.of<AuthenticationProvider>(context, listen: false);
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
        "id": "${_authProvider.user!.uid}",
        "email": "${_authProvider.user!.email}",
        "phonenumber": "${_authProvider.user!.phoneNumber}",
        "name": "${_authProvider.user!.displayName}"
      }
    }),
  );
  final jsonResponse = Map<String, dynamic>.from(json.decode(response.body));
  if (response.statusCode == 200) {
    if (jsonResponse['status'] == 'success') {
      final _url = jsonResponse['data']['link'];
      _launchURL(_url, context);
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
