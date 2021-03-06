import 'dart:io';

import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/models/services_recommendations.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/bnpl/merchant_bnpl_profile.dart';
import 'package:beammart/screens/merchants/merchants_home_screen.dart';
import 'package:beammart/services/recommendations_service.dart';
import 'package:beammart/services/services_recs.dart';
import 'package:beammart/widgets/location_request_widget.dart';
import 'package:beammart/widgets/recommendations_result_card.dart';
import 'package:beammart/widgets/recs_shimmer.dart';
import 'package:beammart/widgets/search_bar_widget.dart';
import 'package:beammart/widgets/services_recs_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ExploreWidget extends StatefulWidget {
  @override
  _ExploreWidgetState createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  Future<ItemRecommendations>? _recsCall;

  String _groupValue = "Products";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LatLng?>(context, listen: false);
    _recsCall = getRecs(context);
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    // final LatLng? _locationProvider =
    //     Provider.of<LatLng?>(context, listen: true);
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
    final _locProvider = Provider.of<LocationProvider>(context);
    final LatLng? _locationProvider = Provider.of<LocationProvider>(
      context,
    ).currentLoc;
    String? deviceId;
    if (Platform.isAndroid) {
      if (deviceProvider != null) {
        deviceId = deviceProvider['androidId'];
      }
    }
    if (Platform.isIOS) {
      if (deviceProvider != null) {
        deviceId = deviceProvider['identifierForVendor'];
      }
    }
    return SafeArea(
      child: ListView(
        children: [
          // Offline bar
          // (_connectionStatus == ConnectivityStatus.Offline)
          //     ? Container(
          //         color: Colors.redAccent,
          //         child: Text('You are currently Offline'),
          //       )
          //     :
          // Search bar
          SearchBarWidget(),
          LocationRequestWidget(),
          Container(
            margin: EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 300, height: 40),
              child: ElevatedButton(
                onPressed: () {
                  // _launchUrl(_merchantsAppUrl);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MerchantHomeScreen(),
                    ),
                  );
                },
                child: Text(
                  'Merchant Center',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (_) => MerchantBNPLProfileScreen(),
          //       ),
          //     );
          //   },
          //   child: Text("BNPL Profile"),
          // ),
          CupertinoSegmentedControl<String>(
            borderColor: Colors.pink,
            padding: EdgeInsets.all(10),
            selectedColor: Colors.pink,
            groupValue: _groupValue,
            children: {
              'Products': Text("Products"),
              'Services': Text("Services"),
            },
            onValueChanged: (value) {
              setState(() {
                _groupValue = value;
              });
            },
          ),
          // Make a request to the recommendations api

          (_groupValue == 'Products')
              ? Container(
                  child: FutureBuilder(
                    // future: _recsCall,
                    future: getRecs(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<ItemRecommendations> snapshot) {
                      if ((snapshot.hasData)) {
                        if (snapshot.data!.recommendations!.length < 1) {
                          return Center(
                            child: Text(
                              'Sorry, No Products posted yet',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.recommendations!.length,
                          itemBuilder: (context, index) {
                            return RecommendationsResultCard(
                              index: index,
                              snapshot: snapshot,
                            );
                          },
                        );
                      } else {
                        return RecsShimmer();
                      }
                    },
                  ),
                )
              : Container(
                  child: FutureBuilder(
                    future: getServiceRecs(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<ServicesRecommendations> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return RecsShimmer();
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.recommendations != null &&
                            snapshot.data!.recommendations!.length < 1) {
                          return Center(
                            child: Text(
                              'Sorry, No Services Near You',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.recommendations!.length,
                          itemBuilder: (context, index) {
                            if (snapshot
                                    .data!.recommendations![index].services ==
                                null) {
                              return SizedBox.shrink();
                            }
                            return ServicesRecommendationsResultCard(
                              index: index,
                              snapshot: snapshot,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Sorry, No Services Near You',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
        ],
      ),
    );
  }
}
