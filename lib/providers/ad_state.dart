import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  // Todo: Change in Production
  String get nativeAdUnitId =>
      Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : '';
  String get bannerAdUnitId =>
      Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : '';

  AdListener get adListener => listener;

  final AdListener listener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) {
      ad.dispose();
      print('Ad closed.');
    },
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
    onAppEvent: (ad, name, data) =>
        print('App event : ${ad.adUnitId}, $name, $data'),
    onNativeAdClicked: (ad) => print('Native ad clicked: ${ad.adUnitId}'),
    onNativeAdImpression: (ad) => print('Native ad impression: ${ad.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) =>
        print('User rewarded: ${ad.adUnitId}, ${reward.amount}, ${reward.type}'),
  );
}
