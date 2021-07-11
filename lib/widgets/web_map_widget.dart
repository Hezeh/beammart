import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WebMapWidget extends StatefulWidget {
  final LatLng? merchantLocation;
  final String? merchantName;
  const WebMapWidget({
    Key? key,
    this.merchantLocation,
    this.merchantName,
  }) : super(key: key);

  @override
  State<WebMapWidget> createState() => _WebMapWidgetState();
}

class _WebMapWidgetState extends State<WebMapWidget> {
  Set<Marker>? markers = {};
  @override
  void initState() {
    super.initState();
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
          // onTap: () => _merchantProfileNavigate(context),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueMagenta,
        ),
      );
      markers!.add(merchantMarker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      color: Colors.white,
      child: GoogleMap(
        mapToolbarEnabled: false,
        buildingsEnabled: true,
        markers: Set<Marker>.from(markers!),
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.merchantLocation!.latitude,
            widget.merchantLocation!.longitude,
          ),
          zoom: 17,
          tilt: 10,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          // mapController = controller;
        },
      ),
    );
  }
}
