import 'package:beammart/providers/ad_state.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NativeInlineAd extends StatefulWidget {
  const NativeInlineAd({Key? key}) : super(key: key);

  @override
  _NativeInlineAdState createState() => _NativeInlineAdState();
}

class _NativeInlineAdState extends State<NativeInlineAd> {
  NativeAd? _ad;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AdState adState = Provider.of<AdState>(context);
    Future<void> _createNativeAd(AdState adState) async {
      setState(() {
        _ad = NativeAd(
          adUnitId: adState.nativeAdUnitId,
          factoryId: 'listTile',
          request: AdRequest(),
          listener: adState.nativeAdListener,
        )..load();
      });
    }

    adState.initialization.then((status) {
      setState(() {
        _createNativeAd(adState);
      });
    });
  }

  // @override
  // void dispose() {
  //   // TODO: Dispose a NativeAd object
  //   _ad.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return (_ad != null)
        ? Container(
            child: AdWidget(ad: _ad!),
            // height: 72.0,
            height: 100,
            alignment: Alignment.center,
          )
        : Container();
  }
}
