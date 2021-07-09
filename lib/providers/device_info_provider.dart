import 'package:beammart/services/device_info_service.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoProvider with ChangeNotifier {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, dynamic>? _deviceInfo;

  Map<String, dynamic>? get deviceInfo => _deviceInfo;

  DeviceInfoProvider() {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      onInit();
    }
  }

  Future<void> onInit() async {
    _deviceInfo = await _deviceInfoService.initPlatformState();
    notifyListeners();
  }
}
