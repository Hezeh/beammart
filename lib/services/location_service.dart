import 'dart:async';

import 'package:beammart/models/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  UserLocation? _currentLocation;

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          _locationController.add(UserLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
          ));
        });
      }
    });
  }

  var location = Location();

  Future<UserLocation?> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}
