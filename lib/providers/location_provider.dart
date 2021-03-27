import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  Location location = new Location();

  LocationProvider() {
    init();
  }

  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LatLng _location = LatLng(0, 0);

  LatLng get currentLocation => _location;

  init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final LocationData _locationData = await location.getLocation();
    _location = LatLng(_locationData.latitude!, _locationData.longitude!);
    notifyListeners();
  }
}
