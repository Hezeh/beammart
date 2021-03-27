import 'dart:async';

import 'package:beammart/enums/connectivity_status.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectivityStatusController =
      StreamController<ConnectivityStatus>();
  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      var connectionStatus = _getStatusFromResult(result);
      connectivityStatusController.add(connectionStatus);
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Mobile;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
