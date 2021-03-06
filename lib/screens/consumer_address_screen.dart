import 'dart:async';

import 'package:beammart/models/consumer_address.dart';
import 'package:beammart/models/item.dart';
import 'package:beammart/models/place.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/providers/theme_provider.dart';
import 'package:beammart/screens/confirm_and_payment_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/services/places_service.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ConsumerAddressScreen extends StatefulWidget {
  final bool? checkout;
  final int? quantity;
  final String? itemId;
  final String? itemTitle;
  final String? itemDescription;
  final String? merchantId;
  final int? price;
  final String? itemImage;
  final Item? item;

  const ConsumerAddressScreen({
    Key? key,
    this.checkout = false,
    this.quantity,
    this.itemId,
    this.itemTitle,
    this.itemDescription,
    this.merchantId,
    this.price,
    this.itemImage,
    this.item,
  }) : super(key: key);

  @override
  State<ConsumerAddressScreen> createState() => _ConsumerAddressScreenState();
}

class _ConsumerAddressScreenState extends State<ConsumerAddressScreen> {
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _googleMapController = Completer();
  final placesService = PlacesService();
  bool _loading = false;
  List<ConsumerAddress?> allAddresses = [];
  int? groupValue;

  _placeMarker(String markerId, double lat, double lon) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lon),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    if (_authProvider.user != null) {
      getUserAddresses(_authProvider.user!.uid);
    } else {}
  }

  getUserAddresses(String userId) async {
    final _docRef =
        FirebaseFirestore.instance.collection('consumers').doc(userId);
    final GoogleMapController _controller = await _googleMapController.future;
    final _addressDocs = await _docRef.get().then((value) {
      final _docData = value.data();
      if (_docData != null) {
        final _addresses = _docData['addresses'];
        final _groupValue = _docData['selectedAddress'];
        setState(() {
          groupValue = _groupValue;
        });
        List<ConsumerAddress?>? _userAddresses = [];
        _addresses.forEach((_address) {
          final _jsonAddress = ConsumerAddress.fromJson(_address);
          _userAddresses.add(_jsonAddress);
        });
        setState(() {
          final _selectedAddress = _userAddresses[_groupValue];
          if (_selectedAddress != null) {
            final _selectedAddressName = _selectedAddress.addressName;
            final _selectedAddressLat = _selectedAddress.addressLat;
            final _selectedAddressLon = _selectedAddress.addressLon;

            _markers.clear();
            _placeMarker(
              _selectedAddressName!,
              _selectedAddressLat!,
              _selectedAddressLon!,
            );
            _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 17,
                  target: LatLng(
                    _selectedAddressLat,
                    _selectedAddressLon,
                  ),
                ),
              ),
            );
          }
        });
        return _userAddresses;
      }
    });
    setState(() {
      if (_addressDocs != null) {
        allAddresses = _addressDocs;
      }
    });
  }

  saveUserAddresses() async {
    final _authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    if (_authProvider.user != null) {
      final _userId = _authProvider.user!.uid;
      final _docRef =
          FirebaseFirestore.instance.collection('consumers').doc(_userId);
      final List<Map<String, dynamic>> _data = [];
      allAddresses.forEach((address) {
        final _jsonAddress = address!.toJson();
        _data.add(_jsonAddress);
      });
      await _docRef.set(
        {
          'addresses': FieldValue.arrayUnion(_data),
          'selectedAddress': groupValue
        },
        SetOptions(merge: true),
      ).then(
        (value) => Navigator.of(context).pop(),
      );
    }
  }

  Future<void> changeMapLocation(double lat, double lon) async {
    final GoogleMapController _controller = await _googleMapController.future;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 17,
          target: LatLng(lat, lon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    final _locationProvider = Provider.of<LocationProvider>(context);
    final LatLng? _currentLocation = _locationProvider.currentLoc;
    final _themeProvider = Provider.of<ThemeProvider>(context);
    // Use Current Location
    if (_authProvider.user == null) {
      return LoginScreen(
        showCloseIcon: true,
      );
    }
    return Scaffold(
      persistentFooterButtons: [
        (widget.checkout != null)
            ? (!widget.checkout!)
                ? (allAddresses.length > 0)
                    ? ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: ElevatedButton(
                          child: Text("Save Address Info"),
                          onPressed: () {
                            saveUserAddresses();
                          },
                        ),
                      )
                    : SizedBox.shrink()
                : (allAddresses.length > 0)
                    ? ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: ElevatedButton(
                          child: Text("Continue"),
                          onPressed: () {
                            // saveUserAddresses();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ConfirmAndPaymentScreen(
                                  itemImage: widget.itemImage,
                                  itemDescription: widget.itemDescription,
                                  itemTitle: widget.itemTitle,
                                  itemQuantity: widget.quantity,
                                  price: widget.price,
                                  shippingAddress: allAddresses[groupValue!],
                                  item: widget.item,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink()
            : SizedBox.shrink(),
      ],
      appBar: AppBar(
        title: Text("Delivery Address"),
      ),
      body: Container(
        child: Stack(
          children: [
            // Google Maps Location
            (_currentLocation != null)
                ? Container(
                    height: 300,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GoogleMap(
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _googleMapController.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation,
                        zoom: 17,
                      ),
                    ),
                  )
                // Show a button when user has delivery address
                : Container(
                    height: 300,
                    margin: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: GoogleMap(
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        _googleMapController.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(0.0, 0.0),
                        zoom: 1,
                      ),
                    ),
                  ),
            DraggableScrollableSheet(
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  child: Container(
                    // color: Colors.white,
                    color: _themeProvider.isLightTheme!
                        ? Colors.white
                        : Color(0XFF0c0c0c),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Add Delivery Address",
                              style: GoogleFonts.gelasio(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // newAddresses.clear();
                            final result = await searchLocationUtil(context);
                            if (result != null) {
                              setState(() {
                                _loading = true;
                              });
                              final placeId = result.placeId;
                              Place _sLocation =
                                  await placesService.getPlace(placeId);

                              final _lat = _sLocation.geometry!.location!.lat;
                              final _lon = _sLocation.geometry!.location!.lng;

                              ConsumerAddress _newConsumerAddress =
                                  ConsumerAddress(
                                addressName: _sLocation.name,
                                addressDescription: _sLocation.vicinity,
                                addressLat: _lat,
                                addressLon: _lon,
                                placeId: placeId,
                              );

                              setState(() {
                                _loading = false;
                                _markers.clear();
                                _placeMarker(_sLocation.name!, _lat!, _lon!);
                                allAddresses.add(_newConsumerAddress);
                                groupValue = allAddresses.length - 1;
                              });
                              await changeMapLocation(_lat!, _lon!);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: Colors.pink,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: Icon(
                                    Icons.search_outlined,
                                    size: 30,
                                    color: Colors.pink,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Search for city, street, town, building",
                                  style: GoogleFonts.roboto(
                                    color: Colors.pink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (_loading)
                            ? LinearProgressIndicator()
                            : SizedBox.shrink(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allAddresses.length,
                          itemBuilder: (context, index) {
                            return Container(
                              // color: Colors.pink,
                              child: RadioListTile(
                                groupValue: groupValue,
                                value: index,
                                onChanged: (int? value) {
                                  final _lat = allAddresses[index]!.addressLat;
                                  final _lon = allAddresses[index]!.addressLon;
                                  final _placeName =
                                      allAddresses[index]!.addressName;

                                  setState(() {
                                    groupValue = value;
                                    _markers.clear();
                                    _placeMarker(_placeName!, _lat!, _lon!);
                                  });
                                  changeMapLocation(_lat!, _lon!);
                                },
                                title:
                                    Text("${allAddresses[index]!.addressName}"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
