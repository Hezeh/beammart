import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/utils/location_request_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LocationRequestWidget extends StatelessWidget {
  const LocationRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _locationProvider = Provider.of<LocationProvider>(context);
    print("Location Service: ${_locationProvider.isLocationServiceEnabled}");
    print("Location Permission: ${_locationProvider.locationPermission}");
    // return (_locationProvider.enabling == null ||
    //         !_locationProvider.enabling! ||
    //         _locationProvider.isLocationServiceEnabled == null ||
    //         !_locationProvider.isLocationServiceEnabled!)
    return (_locationProvider.isLocationServiceEnabled == null ||
            _locationProvider.isLocationServiceEnabled ==
                ServiceStatus.disabled)
        ? Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.purple,
                  ],
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      locationServiceMessage,
                      style: GoogleFonts.oswald(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(height: 50, width: 200),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      _locationProvider.enableLocationService();
                    },
                    child: Text(
                      "Turn Location On",
                      style: GoogleFonts.roboto(
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        : (_locationProvider.locationPermission == null ||
                _locationProvider.locationPermission ==
                    LocationPermission.denied)
            ? Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink,
                        Colors.purple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          locationRequestMessage,
                          style: GoogleFonts.oswald(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 50, width: 200),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () {
                          _locationProvider.enableLocationPermission();
                        },
                        child: Text(
                          "Enable Location",
                          style: GoogleFonts.roboto(
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            : (_locationProvider.locationPermission != null &&
                    _locationProvider.locationPermission ==
                        LocationPermission.deniedForever)
                ? Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.purple,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              locationSettingsMessage,
                              style: GoogleFonts.oswald(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(height: 50, width: 200),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              _locationProvider.openAppSettings();
                            },
                            child: Text(
                              "Change Location Settings",
                              style: GoogleFonts.roboto(
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  )
                : Container();
  }
}
