import 'dart:io';

import 'package:beammart/models/google_maps_directions.dart' as directions;
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/merchant_profile.dart';
import 'package:beammart/services/google_maps_directions_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/widgets/display_images_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
  double zoom = 18;

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
      width: 8,
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
    final List<LatLng> points = <LatLng>[];
    final _currentLocation =
        Provider.of<LocationProvider>(context).currentLocation;
    final directions.GoogleMapsDirections _mapsResp =
        await googleMapsDirectionsService(
      _currentLocation.latitude,
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
      zoom = (256 / _mapsResp.routes![0].legs![0].distance!.value!.toDouble()) * 100;
      // mapController!.animateCamera();
    });
    final _steps = _mapsResp.routes![0].legs![0].steps!;
    directions.Steps _point;
    for (_point in _steps) {
      final double? _startLat = _point.startLocation!.lat;
      final double? _startLon = _point.startLocation!.lng;
      final double? _endLat = _point.endLocation!.lat;
      final double? _endLon = _point.endLocation!.lng;
      points.add(_createLatLng(_startLat!, _startLon!));
      points.add(_createLatLng(_endLat!, _endLon!));
    }
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
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
    final _locationProvider = Provider.of<LocationProvider>(context);
    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }
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
              myLocationButtonEnabled: false,
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
                        title: Text(
                          '${widget.itemTitle}',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          'Price: Ksh. ${widget.price}',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Product Description',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          '${widget.description}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        merchantProfileClickstream(
                          deviceId,
                          widget.merchantId,
                          DateTime.now().toIso8601String(),
                          widget.currentLocation!.latitude,
                          widget.currentLocation!.longitude,
                        );
                        _merchantProfileNavigate(context);
                      },
                      child: Container(
                        child: ListTile(
                          leading: (widget.merchantPhotoUrl != null)
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      NetworkImage(widget.merchantPhotoUrl!),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.pink,
                                ),
                          title: Text(
                            '${widget.merchantName}',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            '${widget.merchantDescription}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: TextButton(
                            child: Text(
                              'View Profile',
                              style: TextStyle(
                                color: Colors.pink,
                              ),
                            ),
                            onPressed: () {
                              merchantProfileClickstream(
                                deviceId,
                                widget.merchantId,
                                DateTime.now().toIso8601String(),
                                widget.currentLocation!.latitude,
                                widget.currentLocation!.longitude,
                              );
                              _merchantProfileNavigate(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          '${widget.distance!.toStringAsFixed(2)} Km Away',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Address',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          '${widget.locationDescription}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          productPagePhoneCallClickstream(
                            deviceId,
                            widget.itemId,
                            widget.merchantId,
                            DateTime.now().toIso8601String(),
                            _locationProvider.currentLocation.latitude,
                            _locationProvider.currentLocation.longitude,
                          );
                          _makePhoneCall('tel:${widget.phoneNumber}');
                        },
                        child: Text('Call'),
                      ),
                    )
                    // TODO Get More Like This
                    // Container(
                    //   child: Text("More items from this merchant"),
                    // ),
                    // TODO Get Similar Nearby
                    // Container(
                    //   child: Text("Similar items nearby"),
                    // )
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