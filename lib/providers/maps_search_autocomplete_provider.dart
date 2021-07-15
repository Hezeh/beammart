import 'dart:async';

import 'package:beammart/models/geometry.dart';
import 'package:beammart/models/location.dart';
import 'package:beammart/models/place.dart';
import 'package:beammart/models/place_search.dart';
import 'package:beammart/services/places_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsSearchAutocompleteProvider with ChangeNotifier {
  final placesService = PlacesService();

  //Variables
  Position? currentLocation;
  List<PlaceSearch>? searchResults;
  StreamController<Place?> selectedLocation = StreamController.broadcast();
  StreamController<LatLngBounds?> bounds = StreamController.broadcast();
  Place? selectedLocationStatic;
  List<Place>? placeResults;
  String? locationPlaceText;

  MapsSearchAutocompleteProvider() {
    // selectedLocation.stream.listen((place) {
    //   if (place != null) {
    //     locationPlaceText = place.name;
    //     // _locationController.text = place.name!;
    //     // _goToPlace(place);
    //   } else {}
    //   // _locationController.text = "";
    // });
  }

  setCurrentLocation() async {
    // currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
          lat: currentLocation!.latitude,
          lng: currentLocation!.longitude,
        ),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    bounds.close();
    super.dispose();
  }
}
