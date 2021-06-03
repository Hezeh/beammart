import 'dart:io';

import 'package:beammart/models/google_maps_directions.dart' as directions;
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/screens/merchant_profile.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/services/google_maps_directions_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/widgets/display_images_widget.dart';
import 'package:beammart/widgets/more_from_this_merchant.dart';
import 'package:beammart/widgets/you_might_also_like.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ItemDetail extends StatefulWidget {
  final String? itemId;
  final List<String>? imageUrl;
  final int? price;
  final String? itemTitle;
  final String? description;
  final LatLng? currentLocation;
  final LatLng? merchantLocation;
  final double? distance;
  final String? merchantName;
  final String? merchantId;
  final String? merchantDescription;
  final String? dateJoined;
  final String? merchantPhotoUrl;
  final String? phoneNumber;
  final String? locationDescription;
  final bool? isMondayOpen;
  final bool? isTuesdayOpen;
  final bool? isWednesdayOpen;
  final bool? isThursdayOpen;
  final bool? isFridayOpen;
  final bool? isSaturdayOpen;
  final bool? isSundayOpen;
  final String? mondayOpeningTime;
  final String? mondayClosingTime;
  final String? tuesdayOpeningTime;
  final String? tuesdayClosingTime;
  final String? wednesdayOpeningTime;
  final String? wednesdayClosingTime;
  final String? thursdayOpeningTime;
  final String? thursdayClosingTime;
  final String? fridayOpeningTime;
  final String? fridayClosingTime;
  final String? saturdayOpeningTime;
  final String? saturdayClosingTime;
  final String? sundayOpeningTime;
  final String? sundayClosingTime;

  const ItemDetail({
    Key? key,
    this.itemId,
    this.imageUrl,
    this.price,
    this.itemTitle,
    this.description,
    this.currentLocation,
    this.merchantLocation,
    this.distance,
    this.merchantName,
    this.merchantId,
    this.merchantDescription,
    this.dateJoined,
    this.merchantPhotoUrl,
    this.phoneNumber,
    this.locationDescription,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.mondayOpeningTime,
    this.mondayClosingTime,
    this.tuesdayOpeningTime,
    this.tuesdayClosingTime,
    this.wednesdayOpeningTime,
    this.wednesdayClosingTime,
    this.thursdayOpeningTime,
    this.thursdayClosingTime,
    this.fridayOpeningTime,
    this.fridayClosingTime,
    this.saturdayOpeningTime,
    this.saturdayClosingTime,
    this.sundayOpeningTime,
    this.sundayClosingTime,
  }) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  GoogleMapController? mapController;

  Set<Marker>? markers = {};

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  List<LatLng> polylineCoordinates = [];
  CameraTargetBounds bounds = CameraTargetBounds.unbounded;
  double zoom = 17;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _merchantProfileNavigate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MerchantProfile(
          merchantId: widget.merchantId,
          merchantName: widget.merchantName,
          merchantDescription: widget.merchantDescription,
          merchantPhotoUrl: widget.merchantPhotoUrl,
          distance: widget.distance,
          dateJoined: widget.dateJoined,
          phoneNumber: widget.phoneNumber,
          isMondayOpen: widget.isMondayOpen,
          isTuesdayOpen: widget.isTuesdayOpen,
          isWednesdayOpen: widget.isWednesdayOpen,
          isThursdayOpen: widget.isThursdayOpen,
          isFridayOpen: widget.isFridayOpen,
          isSaturdayOpen: widget.isSaturdayOpen,
          isSundayOpen: widget.isSundayOpen,
          mondayOpeningTime: widget.mondayOpeningTime,
          mondayClosingTime: widget.mondayClosingTime,
          tuesdayOpeningTime: widget.tuesdayOpeningTime,
          tuesdayClosingTime: widget.tuesdayClosingTime,
          wednesdayOpeningTime: widget.wednesdayOpeningTime,
          wednesdayClosingTime: widget.wednesdayClosingTime,
          thursdayOpeningTime: widget.thursdayOpeningTime,
          thursdayClosingTime: widget.thursdayClosingTime,
          fridayOpeningTime: widget.fridayOpeningTime,
          fridayClosingTime: widget.fridayClosingTime,
          saturdayOpeningTime: widget.saturdayOpeningTime,
          saturdayClosingTime: widget.saturdayClosingTime,
          sundayOpeningTime: widget.sundayOpeningTime,
          sundayClosingTime: widget.sundayClosingTime,
        ),
      ),
    );
  }

  _placeMarkers() async {
    if (widget.merchantLocation != null) {
      final LatLng merchantCoordinates = widget.merchantLocation!;
      Marker merchantMarker = Marker(
        markerId: MarkerId('$merchantCoordinates'),
        position: LatLng(
          merchantCoordinates.latitude,
          merchantCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
            title: '${widget.merchantName}',
            onTap: () => _merchantProfileNavigate(context)),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueMagenta,
        ),
      );
      markers!.add(merchantMarker);
    }
  }

  _addPolyline() async {
    final _uuid = Uuid().v4();
    final String polylineVal = 'polyline_id_$_uuid';
    final PolylineId polylineId = PolylineId(polylineVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.pink,
      width: 5,
      points: await _createPoints(),
      onTap: () {},
      endCap: Cap.roundCap,
      startCap: Cap.buttCap,
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  Future<List<LatLng>> _createPoints() async {
    List<LatLng> points = <LatLng>[];
    final _currentLocation = Provider.of<LatLng?>(context);
    final directions.GoogleMapsDirections _mapsResp =
        await googleMapsDirectionsService(
      _currentLocation!.latitude,
      _currentLocation.longitude,
      widget.merchantLocation!.latitude,
      widget.merchantLocation!.longitude,
    );
    final _mapBounds = _mapsResp.routes![0].bounds;
    bounds = CameraTargetBounds(
      LatLngBounds(
        southwest:
            LatLng(_mapBounds!.southwest!.lat!, _mapBounds.southwest!.lng!),
        northeast:
            LatLng(_mapBounds.northeast!.lat!, _mapBounds.northeast!.lng!),
      ),
    );
    setState(() {
      // TODO: Animate Camera
      zoom = (256 / _mapsResp.routes![0].legs![0].distance!.value!.toDouble()) *
          100;
      // mapController!.animateCamera();
    });
    // final _steps = _mapsResp.routes![0].legs![0].steps!;
    // directions.Steps _point;
    // for (_point in _steps) {
    //   final double? _startLat = _point.startLocation!.lat;
    //   final double? _startLon = _point.startLocation!.lng;
    //   final double? _endLat = _point.endLocation!.lat;
    //   final double? _endLon = _point.endLocation!.lng;
    //   points.add(_createLatLng(_startLat!, _startLon!));
    //   points.add(_createLatLng(_endLat!, _endLon!));
    // }
    // return points;
    final polyPoints = _mapsResp.routes![0].overviewPolyline!.points;
    // return decodeEncodedPolyline(polyPoints!);
    final List<LatLng> polyLatLng = decodeEncodedPolyline(polyPoints!);
    print(polyLatLng);
    points = polyLatLng;
    return points;
  }

  // LatLng _createLatLng(double lat, double lng) {
  //   return LatLng(lat, lng);
  // }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = new LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  @override
  void initState() {
    super.initState();
    _placeMarkers();
  }

  @override
  void didChangeDependencies() {
    _addPolyline();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
    // final _locationProvider = Provider.of<LocationProvider>(context);
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    String? deviceId;
    String? chatId;
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }
    getChatId() async {
      if (_authProvider.user != null) {
        final _chatSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .where(
              'consumerId',
              isEqualTo: _authProvider.user!.uid,
            )
            .where(
              'businessId',
              isEqualTo: widget.merchantId,
            )
            .get();
        chatId = _chatSnapshot.docs.first.id;
      } else {
        chatId = uuid.v4();
      }
    }

    getChatId();
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () => searchUtil(context),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: (MediaQuery.of(context).size.height / 3) * 2,
            child: GoogleMap(
              mapToolbarEnabled: false,
              buildingsEnabled: true,
              markers: Set<Marker>.from(markers!),
              cameraTargetBounds: bounds,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.merchantLocation!.latitude,
                  widget.merchantLocation!.longitude,
                ),
                zoom: zoom,
                tilt: 10,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            builder: (context, scrollController) => ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              child: Container(
                color: Colors.white,
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
                      height: 400,
                      child: DisplayImagesWidget(
                        images: widget.imageUrl,
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: (widget.itemTitle != null)
                            ? Text(
                                '${widget.itemTitle}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : Text(""),
                        subtitle: (widget.description != null)
                            ? Text(
                                '${widget.description}',
                                style: GoogleFonts.roboto(),
                              )
                            : Text(""),
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        title: (widget.price != null)
                            ? Text(
                                'Ksh. ${widget.price}',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : Text(""),
                        trailing: (_authProvider.user != null)
                            ? StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('consumers')
                                    .doc(_authProvider.user!.uid)
                                    .collection('favorites')
                                    .doc(widget.itemId)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snap) {
                                  if (snap.hasData) {
                                    if (snap.data != null &&
                                        snap.data!.exists) {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () {
                                          // Remove from firestore
                                          deleteFavorite(
                                            _authProvider.user!.uid,
                                            widget.itemId!,
                                          );
                                        },
                                      );
                                    } else {
                                      return IconButton(
                                        icon: Icon(
                                            Icons.favorite_border_outlined),
                                        onPressed: () {
                                          // Add to firestore
                                          createFavorite(
                                            _authProvider.user!.uid,
                                            widget.itemId!,
                                          );
                                        },
                                      );
                                    }
                                  }
                                  return Text("");
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.favorite_border_outlined,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(
                                        showCloseIcon: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    Divider(
                      color: Colors.pink,
                      thickness: 3,
                      endIndent: 10,
                      indent: 10,
                    ),

                    InkWell(
                      onTap: () {
                        if (widget.currentLocation != null) {
                          clickstreamUtil(
                            deviceId: deviceId,
                            timeStamp: DateTime.now().toIso8601String(),
                            lat: widget.currentLocation!.latitude,
                            lon: widget.currentLocation!.longitude,
                            type: 'ProfileClick',
                            merchantId: widget.merchantId,
                          );
                        }

                        _merchantProfileNavigate(context);
                      },
                      child: ListTile(
                        // leading: (widget.merchantPhotoUrl != null)
                        //     ? CircleAvatar(
                        //         radius: 40,
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage:
                        //             NetworkImage(widget.merchantPhotoUrl!),
                        //       )
                        //     : CircleAvatar(
                        //         backgroundColor: Colors.pink,
                        //       ),
                        leading: Container(
                          child: (widget.merchantPhotoUrl != null)
                              ? CachedNetworkImage(
                                  imageUrl: widget.merchantPhotoUrl!,
                                  imageBuilder: (context, imageProvider) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          colorFilter: ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.colorBurn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) {
                                    return SizedBox(
                                      child: Shimmer.fromColors(
                                        child: Card(
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.white,
                                          ),
                                        ),
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : SizedBox.shrink(),
                        ),
                        title: (widget.merchantName != null)
                            ? Text(
                                '${widget.merchantName}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : Text(""),
                        subtitle: (widget.merchantDescription != null)
                            ? Text(
                                '${widget.merchantDescription}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(""),
                        trailing: TextButton(
                          child: Text(
                            'View Profile',
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                          onPressed: () {
                            if (widget.currentLocation != null) {
                              clickstreamUtil(
                                deviceId: deviceId,
                                timeStamp: DateTime.now().toIso8601String(),
                                lat: widget.currentLocation!.latitude,
                                lon: widget.currentLocation!.longitude,
                                type: 'ProfileClick',
                                merchantId: widget.merchantId,
                              );
                            }
                            _merchantProfileNavigate(context);
                          },
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        title: (widget.distance != null)
                            ? Text(
                                '${widget.distance!.toStringAsFixed(2)} Km Away',
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                            : SizedBox.shrink(),
                        subtitle: (widget.locationDescription != null)
                            ? Text(
                                '${widget.locationDescription}',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        (widget.phoneNumber != null)
                            ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 150,
                                ),
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.call_outlined),
                                  onPressed: () {
                                    if (widget.currentLocation != null) {
                                      clickstreamUtil(
                                        deviceId: deviceId,
                                        timeStamp:
                                            DateTime.now().toIso8601String(),
                                        lat: widget.currentLocation!.latitude,
                                        lon: widget.currentLocation!.longitude,
                                        type: 'ItemPhoneClick',
                                        merchantId: widget.merchantId,
                                        itemId: widget.itemId,
                                        // category: widget.
                                      );
                                    }
                                    _makePhoneCall('tel:${widget.phoneNumber}');
                                  },
                                  label: Text('Call'),
                                ),
                              )
                            : Container(),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 150,
                          ),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.chat_bubble_outline_outlined,
                            ),
                            onPressed: () {
                              if (_authProvider.user != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      chatId: chatId,
                                      businessName: widget.merchantName,
                                      businessId: widget.merchantId,
                                      businessPhotoUrl: widget.merchantPhotoUrl,
                                      consumerDisplayName:
                                          _authProvider.user!.displayName,
                                      consumerId: _authProvider.user!.uid,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(
                                      showCloseIcon: true,
                                    ),
                                  ),
                                );
                              }
                            },
                            label: Text("Chat"),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Center(
                        child: Text(
                          "More from this merchant",
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    MoreFromThisMerchant(
                      merchantId: widget.merchantId!,
                      itemId: widget.itemId!,
                    ),

                    // TODO You may also like these
                    // Container(
                    //   margin: EdgeInsets.only(
                    //     top: 10,
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "You might also like these",
                    //       style: GoogleFonts.nunito(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // YouMightAlsoLike(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
