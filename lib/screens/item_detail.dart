import 'package:beammart/screens/merchant_profile.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/widgets/display_images_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetail extends StatefulWidget {
  final String itemId;
  final List<String> imageUrl;
  final int price;
  final String itemTitle;
  final String description;
  final LatLng currentLocation;
  final LatLng merchantLocation;
  final double distance;
  final String merchantName;
  final String merchantId;
  final String merchantDescription;
  final String dateJoined;
  final String merchantPhotoUrl;
  final String phoneNumber;
  final String locationDescription;
  final bool isMondayOpen;
  final bool isTuesdayOpen;
  final bool isWednesdayOpen;
  final bool isThursdayOpen;
  final bool isFridayOpen;
  final bool isSaturdayOpen;
  final bool isSundayOpen;
  final String mondayOpeningTime;
  final String mondayClosingTime;
  final String tuesdayOpeningTime;
  final String tuesdayClosingTime;
  final String wednesdayOpeningTime;
  final String wednesdayClosingTime;
  final String thursdayOpeningTime;
  final String thursdayClosingTime;
  final String fridayOpeningTime;
  final String fridayClosingTime;
  final String saturdayOpeningTime;
  final String saturdayClosingTime;
  final String sundayOpeningTime;
  final String sundayClosingTime;

  const ItemDetail({
    Key key,
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
  GoogleMapController mapController;

  Set<Marker> markers = {};

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

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
      final LatLng merchantCoordinates = widget.merchantLocation;
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
      markers.add(merchantMarker);
    }
  }

  @override
  void initState() {
    super.initState();
    _placeMarkers();
  }

  @override
  Widget build(BuildContext context) {
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
          GoogleMap(
            markers: markers != null ? Set<Marker>.from(markers) : null,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.merchantLocation.latitude,
                widget.merchantLocation.longitude,
              ),
              zoom: 18,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          DraggableScrollableSheet(
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
                        _merchantProfileNavigate(context);
                      },
                      child: Container(
                        child: ListTile(
                          leading: (widget.merchantPhotoUrl != null)
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      NetworkImage(widget.merchantPhotoUrl),
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
                          trailing: FlatButton(
                            child: Text(
                              'View Profile',
                              style: TextStyle(
                                color: Colors.pink,
                              ),
                            ),
                            onPressed: () {
                              _merchantProfileNavigate(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                          '${widget.distance.toStringAsFixed(2)} Km Away',
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
                          _makePhoneCall('tel:${widget.phoneNumber}');
                        },
                        child: Text('Call'),
                      ),
                    )
                    // TODO Make a http request
                    // Container(
                    //   child: Text("More items from this merchant"),
                    // ),
                    // TODO Make a http request
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
