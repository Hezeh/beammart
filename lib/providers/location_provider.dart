import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider {
  Location location = Location();
  // LatLng? _currentLocation;

  StreamController<LatLng> _locationController = StreamController<LatLng>();
  Stream<LatLng> get currentLocation => _locationController.stream;

  LocationProvider() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          _locationController.add(LatLng(
            locationData.latitude!,
            locationData.longitude!,
          ));
        });
      }
    });
    // init();
  }

  // Stream<LocationData> get currentLocation {
  //   return location.getLocation().asStream();
  // }

  late bool _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LatLng? _location;

  // LatLng? get currentLocation => _location;

  // Future<LatLng?> getLocation() async {
  //   try {
  //     var userLocation = await location.getLocation();
  //     _currentLocation = LatLng(
  //       userLocation.latitude!,
  //       userLocation.longitude!,
  //     );
  //   } on Exception catch (e) {
  //     print('Could not get location: ${e.toString()}');
  //   }
  //   return _currentLocation;
  // }

  // init() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   final LocationData _locationData = await location.getLocation();
  //   _location = LatLng(_locationData.latitude!, _locationData.longitude!);
  //   notifyListeners();
  // }
}
