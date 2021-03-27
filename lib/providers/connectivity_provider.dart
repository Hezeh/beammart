import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ConnectivityProvider with ChangeNotifier {
  String connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  // Getters
  // StreamSubscription<ConnectivityResult>  connectivitySubscription =
  //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = result.toString();
        break;
      default:
        connectionStatus = 'Failed to get connectivity';
        break;
    }
    notifyListeners();
  }
}
