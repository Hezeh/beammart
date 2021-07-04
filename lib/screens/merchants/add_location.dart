import 'dart:async';

import 'package:beammart/models/place.dart';
import 'package:beammart/providers/add_business_profile_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/providers/maps_search_autocomplete_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddLocationMap extends StatefulWidget {
  static const String routeName = '/add-location';
  final GeoPoint? currentLocation;
  final String? businessName;
  final String? businessDescription;
  final String? city;
  final String? locationDescription;
  final String? mondayOpeningHour;
  final String? mondayClosingHour;
  final String? tuesdayOpeningHour;
  final String? tuesdayClosingHour;
  final String? wednesdayOpeningHour;
  final String? wednesdayClosingHour;
  final String? thursdayOpeningHour;
  final String? thursdayClosingHour;
  final String? fridayOpeningHour;
  final String? fridayClosingHour;
  final String? saturdayOpeningHour;
  final String? saturdayClosingHour;
  final String? sundayOpeningHour;
  final String? sundayClosingHour;
  final String? phoneNumber;

  const AddLocationMap({
    Key? key,
    this.currentLocation,
    this.businessName,
    this.city,
    this.locationDescription,
    this.businessDescription,
    this.mondayOpeningHour,
    this.mondayClosingHour,
    this.tuesdayOpeningHour,
    this.tuesdayClosingHour,
    this.wednesdayOpeningHour,
    this.wednesdayClosingHour,
    this.thursdayOpeningHour,
    this.thursdayClosingHour,
    this.fridayOpeningHour,
    this.fridayClosingHour,
    this.saturdayOpeningHour,
    this.saturdayClosingHour,
    this.sundayOpeningHour,
    this.sundayClosingHour,
    this.phoneNumber,
  }) : super(key: key);

  @override
  _AddLocationMapState createState() => _AddLocationMapState();
}

class _AddLocationMapState extends State<AddLocationMap> {
  final _locationController = TextEditingController();
  final Set<Marker> _markers = {};
  // Location location = new Location();
  double? _latitude = -1.3032051;
  double? _longitude = 36.707307;
  bool _isMapCreated = false;
  // GoogleMapController? _controller;
  CameraPosition? _cameraPosition = CameraPosition(
    target: LatLng(
      -1.3032051,
      36.707307,
    ),
    zoom: 15,
  );
  bool _saving = false;
  Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;
  late StreamSubscription boundsSubscription;

  Future<void> _getCurrentLocation() async {
    // final _locationData = await location.getLocation();
    final _locationData = Provider.of<LocationProvider>(context).currentLoc;
    if (_locationData != null) {
      final CameraPosition currentPosition = CameraPosition(
        target: LatLng(
          _locationData.latitude,
          _locationData.longitude,
        ),
        zoom: 50,
      );
      setState(() {
        _latitude = _locationData.latitude;
        _longitude = _locationData.longitude;
        _cameraPosition = currentPosition;
        _markers.add(
          Marker(
            markerId: MarkerId(_cameraPosition.toString()),
            position: LatLng(_locationData.latitude, _locationData.longitude),
            onTap: () {},
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          ),
        );
      });
      print("Done Getting Location");
    }
  }

  @override
  void initState() {
    // getCurrentLocation();
    _markers.add(
      Marker(
        markerId: MarkerId(_cameraPosition.toString()),
        position: LatLng(
          _latitude!,
          _longitude!,
        ),
        onTap: () {},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );
    final _mapsAutocompleteProvider =
        Provider.of<MapsSearchAutocompleteProvider>(context, listen: false);

    //Listen for selected Location
    locationSubscription =
        _mapsAutocompleteProvider.selectedLocation.stream.listen((place) {
      if (place != null) {
        _locationController.text = place.name!;
        _goToPlace(place);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(_cameraPosition.toString()),
            position: LatLng(
              place.geometry!.location!.lat as double,
              place.geometry!.location!.lng as double,
            ),
            onTap: () {},
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          ),
        );
        setState(() {
          _latitude = place.geometry!.location!.lat;
          _longitude = place.geometry!.location!.lng;
        });
      } else
        _locationController.text = "";
    });

    _mapsAutocompleteProvider.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds!, 50));
    });
    super.initState();
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(place.geometry!.location!.lat as double,
              place.geometry!.location!.lng as double),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    final _mapsAutocompleteProvider =
        Provider.of<MapsSearchAutocompleteProvider>(context, listen: false);
    _mapsAutocompleteProvider.dispose();
    _locationController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _profileProvider = Provider.of<ProfileProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    final _businessProfileProvider =
        Provider.of<AddBusinessProfileProvider>(context);
    final _mapsAutocompleteProvider =
        Provider.of<MapsSearchAutocompleteProvider>(context);
    return Scaffold(
      appBar: (widget.currentLocation != null)
          ? AppBar(
              title: Text("Edit Shop Location"),
              actions: [
                (_latitude != null && _longitude != null)
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _saving = true;
                          });
                          _profileProvider.changeLocation(
                            _profileProvider.profile!.userId!,
                            GeoPoint(_latitude!, _longitude!),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container()
              ],
            )
          : AppBar(
              title: Text('Shop Location'),
              actions: [
                (_latitude != null && _longitude != null)
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            _saving = true;
                          });
                          Map<String, dynamic> _data = {
                            'tokensBalance': 50,
                            'tokensInUse': 0,
                            'gpsLocation': GeoPoint(_latitude!, _longitude!)
                          };

                          if (_businessProfileProvider
                                  .profile.businessProfilePhoto !=
                              null) {
                            _data['businessProfilePhoto'] =
                                _businessProfileProvider
                                    .profile.businessProfilePhoto;
                          }
                          if (_businessProfileProvider.profile.businessName !=
                              null) {
                            _data['businessName'] =
                                _businessProfileProvider.profile.businessName;
                          }
                          if (_businessProfileProvider
                                  .profile.businessDescription !=
                              null) {
                            _data['businessDescription'] =
                                _businessProfileProvider
                                    .profile.businessDescription;
                          }
                          if (_businessProfileProvider.profile.city != null) {
                            _data['city'] =
                                _businessProfileProvider.profile.city;
                          }
                          if (_businessProfileProvider
                                  .profile.locationDescription !=
                              null) {
                            _data['locationDescription'] =
                                _businessProfileProvider
                                    .profile.locationDescription;
                          }
                          if (_businessProfileProvider.profile.phoneNumber !=
                              null) {
                            _data['phoneNumber'] =
                                _businessProfileProvider.profile.phoneNumber;
                          }
                          if (_businessProfileProvider
                                  .profile.mondayOpeningHours !=
                              null) {
                            _data['mondayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.mondayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.mondayClosingHours !=
                              null) {
                            _data['mondayClosingHours'] =
                                _businessProfileProvider
                                    .profile.mondayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.tuesdayOpeningHours !=
                              null) {
                            _data['tuesdayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.tuesdayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.tuesdayClosingHours !=
                              null) {
                            _data['tuesdayClosingHours'] =
                                _businessProfileProvider
                                    .profile.tuesdayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.wednesdayOpeningHours !=
                              null) {
                            _data['wednesdayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.wednesdayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.wednesdayClosingHours !=
                              null) {
                            _data['wednesdayClosingHours'] =
                                _businessProfileProvider
                                    .profile.wednesdayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.thursdayOpeningHours !=
                              null) {
                            _data['thursdayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.thursdayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.thursdayClosingHours !=
                              null) {
                            _data['thursdayClosingHours'] =
                                _businessProfileProvider
                                    .profile.thursdayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.fridayOpeningHours !=
                              null) {
                            _data['fridayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.fridayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.fridayClosingHours !=
                              null) {
                            _data['fridayClosingHours'] =
                                _businessProfileProvider
                                    .profile.fridayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.saturdayOpeningHours !=
                              null) {
                            _data['saturdayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.saturdayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.saturdayClosingHours !=
                              null) {
                            _data['saturdayClosingHours'] =
                                _businessProfileProvider
                                    .profile.saturdayClosingHours;
                          }
                          if (_businessProfileProvider
                                  .profile.sundayOpeningHours !=
                              null) {
                            _data['sundayOpeningHours'] =
                                _businessProfileProvider
                                    .profile.sundayOpeningHours;
                          }
                          if (_businessProfileProvider
                                  .profile.sundayClosingHours !=
                              null) {
                            _data['sundayClosingHours'] =
                                _businessProfileProvider
                                    .profile.sundayClosingHours;
                          }
                          if (_businessProfileProvider.profile.isMondayOpen !=
                              null) {
                            _data['isMondayOpen'] =
                                _businessProfileProvider.profile.isMondayOpen;
                          }
                          if (_businessProfileProvider.profile.isTuesdayOpen !=
                              null) {
                            _data['isTuesdayOpen'] =
                                _businessProfileProvider.profile.isTuesdayOpen;
                          }
                          if (_businessProfileProvider
                                  .profile.isWednesdayOpen !=
                              null) {
                            _data['isWednesdayOpen'] = _businessProfileProvider
                                .profile.isWednesdayOpen;
                          }
                          if (_businessProfileProvider.profile.isThursdayOpen !=
                              null) {
                            _data['isThursdayOpen'] =
                                _businessProfileProvider.profile.isThursdayOpen;
                          }
                          if (_businessProfileProvider.profile.isFridayOpen !=
                              null) {
                            _data['isFridayOpen'] =
                                _businessProfileProvider.profile.isFridayOpen;
                          }
                          if (_businessProfileProvider.profile.isSaturdayOpen !=
                              null) {
                            _data['isSaturdayOpen'] =
                                _businessProfileProvider.profile.isSaturdayOpen;
                          }
                          if (_businessProfileProvider.profile.isSundayOpen !=
                              null) {
                            _data['isSundayOpen'] =
                                _businessProfileProvider.profile.isSundayOpen;
                          }

                          if (currentUser != null) {
                            _data['userId'] = currentUser.uid;
                            _data['storeId'] = currentUser.uid;
                            _data['email'] = currentUser.email;
                            _data['emailVerified'] = currentUser.emailVerified;
                            _data['creationTime'] = currentUser
                                .metadata.creationTime!
                                .toIso8601String();
                            _data['lastSignInTime'] = currentUser
                                .metadata.lastSignInTime!
                                .toIso8601String();
                            if (currentUser.displayName != null) {
                              _data['displayName'] = currentUser.displayName;
                            }
                            if (currentUser.photoURL != null) {
                              _data['photoUrl'] = currentUser.photoURL;
                            }
                          }

                          _profileProvider.addBusinessProfile(
                            _data,
                            currentUser!.uid,
                          );
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(
                          'Finish',
                          style: TextStyle(
                            // color: Colors.pink,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
      body: (_saving == false)
          ? Stack(
              children: [
                (_cameraPosition != null)
                    ? Container(
                        // height: 500,
                        child: GoogleMap(
                          onTap: (LatLng location) {
                            setState(() {
                              _markers.clear();
                              _markers.add(
                                Marker(
                                  markerId:
                                      MarkerId(_cameraPosition.toString()),
                                  position: LatLng(
                                      location.latitude, location.longitude),
                                  onTap: () {},
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRose),
                                ),
                              );
                              _latitude = location.latitude;
                              _longitude = location.longitude;
                            });
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          initialCameraPosition: _cameraPosition!,
                          mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          markers: _markers,
                          trafficEnabled: false,
                          onMapCreated: (controller) {
                            _mapController.complete(controller);
                          },
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                Positioned(
                  top: 10,
                  right: 10,
                  left: 10,
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _locationController,
                      maxLines: 1,
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _locationController.clear();
                            // _mapsAutocompleteProvider.clearSelectedLocation();
                          },
                        ),
                      ),
                      onChanged: (value) {
                        _mapsAutocompleteProvider.searchPlaces(value);
                      },
                    ),
                  ),
                ),
                if (_mapsAutocompleteProvider.searchResults != null &&
                    _mapsAutocompleteProvider.searchResults!.length != 0)
                  Positioned(
                    top: 80,
                    right: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.pinkAccent,
                      ),
                      height: 300.0,
                      child: ListView.builder(
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              _mapsAutocompleteProvider.searchResults!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                "${_mapsAutocompleteProvider.searchResults![index].description}",
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                _mapsAutocompleteProvider.setSelectedLocation(
                                  "${_mapsAutocompleteProvider.searchResults![index].placeId}",
                                );
                              },
                            );
                          }),
                    ),
                  ),
              ],
            )
          : LinearProgressIndicator(),
    );
  }
}
