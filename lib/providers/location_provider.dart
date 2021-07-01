// impo

// class LocationProvider with ChangeNotifier {
//   Location location = Location();
//   // LatLng? _currentLocation;

//   StreamController<LatLng> _locationController = StreamController<LatLng>();
//   Stream<LatLng> get currentLocation => _locationController.stream;

//   LocationProvider() {
//     isLocationPermissionGranted();
//     // if (await location.serviceEnabled()) {}
//   }

//   bool? _serviceEnabled;
//   PermissionStatus? _permissionGranted;
//   LatLng? _location;
//   bool? _enabling;

//   LatLng? get currentLoc => _location;
//   PermissionStatus? get permissionGranted => _permissionGranted;
//   bool? get enabling => _enabling;

//   bool? get isLocationServiceEnabled => _serviceEnabled;

//   isLocationPermissionGranted() async {
//     if (await location.hasPermission() == PermissionStatus.granted) {
//       // location.requestPermission().then((granted) async {
//       //   if (granted == PermissionStatus.granted) {
//       //     // If granted listen to the onLocationChanged stream and emit over our controller
//       //     // location.onLocationChanged.listen((locationData) {
//       //     //   _locationController.add(LatLng(
//       //     //     locationData.latitude!,
//       //     //     locationData.longitude!,
//       //     //   ));
//       //     // });
//       //     _permissionGranted = PermissionStatus.granted;
//       //     final locationData = await location.getLocation();
//       //     _location = LatLng(locationData.latitude as double,
//       //         locationData.longitude as double);
//       //     notifyListeners();
//       //   }
//       // });

//       _permissionGranted = PermissionStatus.granted;
//       final _isServiceEnabled = await location.serviceEnabled();
//       _serviceEnabled = _isServiceEnabled;
//       final _locationData = await location.getLocation();
//       _location = LatLng(
//         _locationData.latitude as double,
//         _locationData.longitude as double,
//       );

//       notifyListeners();
//     } else {
//       final _isServiceEnabled = await location.serviceEnabled();
//       _serviceEnabled = _isServiceEnabled;
//       _permissionGranted = PermissionStatus.denied;
//       notifyListeners();
//     }
//   }

//   enableLocation() {
//     _enabling = true;
//     notifyListeners();
//     location.requestPermission().then((granted) async {
//       if (granted == PermissionStatus.granted) {
//         // // If granted listen to the onLocationChanged stream and emit over our controller
//         // location.onLocationChanged.listen((locationData) {
//         //   _locationController.add(LatLng(
//         //     locationData.latitude!,
//         //     locationData.longitude!,
//         //   ));
//         // });
//         final _isServiceEnabled = await location.serviceEnabled();
//         _serviceEnabled = _isServiceEnabled;
//         final locationData = await location.getLocation();
//         _location = LatLng(
//             locationData.latitude as double, locationData.longitude as double);
//         _permissionGranted = PermissionStatus.granted;
//         _enabling = false;
//         notifyListeners();
//       } else {
//         final _isServiceEnabled = await location.serviceEnabled();
//         _serviceEnabled = _isServiceEnabled;
//         _permissionGranted = PermissionStatus.denied;
//         _enabling = null;
//         notifyListeners();
//       }
//     });
//   }

//   enableService() async {
//     location.requestService();
//     if (await location.serviceEnabled()) {
//       _serviceEnabled = true;
//       notifyListeners();
//     }
//   }
// }
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  ServiceStatus? _serviceStatus;
  LatLng? _location;
  bool? _enabling;
  LocationPermission? _locationPermission;

  LatLng? get currentLoc => _location;
  bool? get enabling => _enabling;

  ServiceStatus? get isLocationServiceEnabled => _serviceStatus;
  LocationPermission? get locationPermission => _locationPermission;

  LocationProvider() {
    checkLocationService();
    checkLocationPermission();
    // getCurrentLocation();
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      print(status);
      _serviceStatus = status;
      notifyListeners();
      // if (status == ServiceStatus.disabled) {
      //   _serviceStatus = ServiceStatus.disabled;
      // } else {
      //   _serviceStatus = ServiceStatus.enabled;
      // }
      // notifyListeners();
    });
  }

  checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) {
      _locationPermission = LocationPermission.whileInUse;
      notifyListeners();
    }
    if (permission == LocationPermission.always) {
      _locationPermission = LocationPermission.always;
      notifyListeners();
    }
    if (permission == LocationPermission.denied) {
      _locationPermission = LocationPermission.denied;
      notifyListeners();
    }

    if (permission == LocationPermission.deniedForever) {
      _locationPermission = LocationPermission.deniedForever;
      notifyListeners();
    }
  }

  enableLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      _enabling = true;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationPermission = LocationPermission.denied;
        notifyListeners();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // _enabling = true;
      // permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) {
      //   _locationPermission = LocationPermission.denied;
      //   notifyListeners();
      // }
      _locationPermission = LocationPermission.deniedForever;
      notifyListeners();
    }
  }

  openAppSettings() {
    Geolocator.openAppSettings();
  }

  checkLocationService() async {
    final _islocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (_islocationEnabled) {
      _serviceStatus = ServiceStatus.enabled;
      notifyListeners();
    } else {
      _serviceStatus = ServiceStatus.disabled;
      notifyListeners();
    }
  }

  enableLocationService() {
    Geolocator.openLocationSettings();
  }

  getCurrentLocation() async {
    Position _position = await _determinePosition();
    _location = LatLng(_position.latitude, _position.longitude);
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition();
  }
}
