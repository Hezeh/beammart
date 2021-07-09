import 'dart:io';

import 'package:beammart/models/device_profile.dart';
import 'package:beammart/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class DeviceProfileProvider with ChangeNotifier {
  DeviceProfile? _deviceProfile;
  final FirestoreService _dbService = FirestoreService();

  DeviceProfile? get deviceProfile => _deviceProfile;

  DeviceProfileProvider(Map<String, dynamic>? deviceInfo) {
   
    if (deviceInfo != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
       print('Getting Android Profile');
        // Get Android Info
        fetchDeviceProfile(deviceInfo['androidId'],
            deviceInfo);

    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      print('Getting IOS Profile');
        // Get iOS Info
        fetchDeviceProfile(deviceInfo['identifierForVendor'],
            deviceInfo);
    }
    }
  }

  fetchDeviceProfile(String? deviceId, Map<String, dynamic> data) async {
    print('Fetching Profile');
    final _data = await _dbService.fetchDeviceProfile(deviceId);
    final DeviceProfile? _deviceData = DeviceProfile.fromJson(_data!);
    if (_deviceData != null) {
      _deviceProfile = _deviceData;
    } else {
      // Create profile
      await _dbService.createDeviceProfile(deviceId!, data);
      _deviceProfile = DeviceProfile.fromJson(data);
    }
    notifyListeners();
    return _deviceProfile;
  }
}
