import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_results.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geolocation;
import 'package:provider/provider.dart';

class MapUiBody extends StatefulWidget {
  final ItemResults? itemResults;
  final LatLngBounds? mapBounds;

  const MapUiBody({Key? key, this.itemResults, this.mapBounds})
      : super(key: key);

  @override
  _MapUiBodyState createState() => _MapUiBodyState();
}

class _MapUiBodyState extends State<MapUiBody> {
  _MapUiBodyState();

  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;

  late GoogleMapController _controller;
  geolocation.Location location = new geolocation.Location();

  final Set<Marker> _markers = {};

  getCurrentLocation() async {
    final _locationData = await location.getLocation();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _locationData.latitude!,
            _locationData.longitude!,
          ),
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
    setState(() {
      _markers.clear();
      for (final Item item in widget.itemResults!.items!) {
        final _marker = Marker(
          markerId: MarkerId(item.price.toString()),
          position: LatLng(
            item.location!.lat!,
            item.location!.lon!,
          ),
          infoWindow: InfoWindow(
            snippet: item.price.toString(),
            title: item.title,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose),
        );
        _markers.add(_marker);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? location = Provider.of<LatLng?>(context);
    return (location != null)
        ? GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                location.latitude,
                location.longitude,
              ),
              zoom: 10
            ),
            cameraTargetBounds: _cameraTargetBounds,
            minMaxZoomPreference: _minMaxZoomPreference,
            mapType: MapType.normal,
            indoorViewEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // onCameraMove: _updateCameraPosition,
            markers: _markers,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  // void _updateCameraPosition(CameraPosition position) {
  //   setState(() {
  //     _position = position;
  //   });
  // }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }
}
