import 'dart:io';

import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/category_view_all.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/services/recommendations_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/widgets/recs_shimmer.dart';
import 'package:beammart/widgets/search_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:beammart/services/favorites_service.dart';

class ExploreWidget extends StatefulWidget {
  @override
  _ExploreWidgetState createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  Future<ItemRecommendations>? _recsCall;

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
    final LatLng? _locationProvider =
        Provider.of<LatLng?>(context, listen: true);
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
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
      child: Column(
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

          // Make a request to the recommendations api

          Container(
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
                  return Flexible(
                    child: ListView.builder(
                      itemCount: snapshot.data!.recommendations!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    clickstreamUtil(
                                      deviceId: deviceId,
                                      index: index,
                                      timeStamp:
                                          DateTime.now().toIso8601String(),
                                      category: snapshot.data!
                                          .recommendations![index].category,
                                      lat: (_locationProvider != null)
                                          ? _locationProvider.latitude
                                          : 0,
                                      lon: (_locationProvider != null)
                                          ? _locationProvider.longitude
                                          : 0,
                                      type: 'CategoryViewAllClick',
                                      recsId: snapshot.data!.recsId,
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CategoryViewAll(
                                          categoryName: snapshot.data!
                                              .recommendations![index].category,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    snapshot.data!.recommendations![index]
                                        .category!,
                                    style: GoogleFonts.oxygen(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () {
                                    clickstreamUtil(
                                      deviceId: deviceId,
                                      index: index,
                                      timeStamp:
                                          DateTime.now().toIso8601String(),
                                      category: snapshot.data!
                                          .recommendations![index].category,
                                      lat: (_locationProvider != null)
                                          ? _locationProvider.latitude
                                          : 0,
                                      lon: (_locationProvider != null)
                                          ? _locationProvider.longitude
                                          : 0,
                                      type: 'CategoryViewAllClick',
                                      recsId: snapshot.data!.recsId,
                                    );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CategoryViewAll(
                                          categoryName: snapshot.data!
                                              .recommendations![index].category,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                height: 350,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!
                                      .recommendations![index].items!.length,
                                  itemBuilder: (context, item) {
                                    final List<Item> _items = snapshot
                                        .data!.recommendations![index].items!;

                                    final double? _lat1 =
                                        (_locationProvider != null)
                                            ? _locationProvider.latitude
                                            : 0;
                                    final double? _lon1 =
                                        (_locationProvider != null)
                                            ? _locationProvider.longitude
                                            : 0;

                                    final double _lat2 =
                                        _items[item].location!.lat!;
                                    final double _lon2 =
                                        _items[item].location!.lon!;
                                    final _distance = coordinateDistance(
                                        _lat1, _lon1, _lat2, _lon2);
                                    return VisibilityDetector(
                                      key: Key('RecommendationsItem'),
                                      onVisibilityChanged: (info) {
                                        if (info.visibleFraction > 0.8) {
                                          final _timeStamp =
                                              DateTime.now().toIso8601String();
                                          // Get itemId
                                          final _itemId = _items[item].itemId;
                                          final _merchantId =
                                              _items[item].businessId;
                                          final String _uniqueViewId =
                                              uuid.v4();
                                          onItemView(
                                            timeStamp: _timeStamp,
                                            deviceId: deviceId,
                                            itemId: _itemId,
                                            viewId: _uniqueViewId,
                                            percentage: info.visibleFraction,
                                            merchantId: _merchantId,
                                            lat: (_locationProvider != null)
                                                ? _locationProvider.latitude
                                                : 0,
                                            lon: (_locationProvider != null)
                                                ? _locationProvider.longitude
                                                : 0,
                                            index: index,
                                            type: 'Recommendations',
                                          );
                                        }
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          final _itemId = _items[item].itemId;
                                          final _merchantId =
                                              _items[item].businessId;

                                          clickstreamUtil(
                                            deviceId: deviceId,
                                            index: index,
                                            timeStamp: DateTime.now()
                                                .toIso8601String(),
                                            category: snapshot
                                                .data!
                                                .recommendations![index]
                                                .category,
                                            lat: (_locationProvider != null)
                                                ? _locationProvider.latitude
                                                : 0,
                                            lon: (_locationProvider != null)
                                                ? _locationProvider.longitude
                                                : 0,
                                            type: 'RecommendationsPageClick',
                                            recsId: snapshot.data!.recsId,
                                            itemId: _itemId,
                                            merchantId: _merchantId,
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ItemDetail(
                                                itemId: _items[item].itemId,
                                                imageUrl: _items[item].images,
                                                itemTitle: _items[item].title,
                                                price: _items[item].price,
                                                merchantLocation: LatLng(
                                                  _items[item].location!.lat!,
                                                  _items[item].location!.lon!,
                                                ),
                                                description:
                                                    _items[item].description,
                                                dateJoined:
                                                    _items[item].dateJoined,
                                                merchantId:
                                                    _items[item].businessId,
                                                locationDescription:
                                                    _items[item]
                                                        .locationDescription,
                                                merchantDescription:
                                                    _items[item]
                                                        .businessDescription,
                                                merchantName:
                                                    _items[item].businessName,
                                                merchantPhotoUrl: _items[item]
                                                    .merchantPhotoUrl,
                                                phoneNumber:
                                                    _items[item].phoneNumber,
                                                currentLocation:
                                                    _locationProvider,
                                                distance: _distance,
                                                isMondayOpen:
                                                    _items[item].isMondayOpen,
                                                isTuesdayOpen:
                                                    _items[item].isTuesdayOpen,
                                                isWednesdayOpen: _items[item]
                                                    .isWednesdayOpen,
                                                isThursdayOpen:
                                                    _items[item].isThursdayOpen,
                                                isFridayOpen:
                                                    _items[item].isFridayOpen,
                                                isSaturdayOpen:
                                                    _items[item].isSaturdayOpen,
                                                isSundayOpen:
                                                    _items[item].isSundayOpen,
                                                mondayOpeningTime: _items[item]
                                                    .mondayOpeningHours,
                                                mondayClosingTime: _items[item]
                                                    .mondayClosingHours,
                                                tuesdayClosingTime: _items[item]
                                                    .tuesdayClosingHours,
                                                tuesdayOpeningTime: _items[item]
                                                    .tuesdayOpeningHours,
                                                wednesdayClosingTime:
                                                    _items[item]
                                                        .wednesdayClosingHours,
                                                wednesdayOpeningTime:
                                                    _items[item]
                                                        .wednesdayOpeningHours,
                                                thursdayClosingTime:
                                                    _items[item]
                                                        .thursdayClosingHours,
                                                thursdayOpeningTime:
                                                    _items[item]
                                                        .thursdayOpeningHours,
                                                fridayClosingTime: _items[item]
                                                    .fridayClosingHours,
                                                fridayOpeningTime: _items[item]
                                                    .fridayOpeningHours,
                                                saturdayClosingTime:
                                                    _items[item]
                                                        .saturdayClosingHours,
                                                saturdayOpeningTime:
                                                    _items[item]
                                                        .saturdayOpeningHours,
                                                sundayClosingTime: _items[item]
                                                    .sundayClosingHours,
                                                sundayOpeningTime: _items[item]
                                                    .sundayOpeningHours,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 280,
                                          margin: EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: GridTile(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _items[item].images!.first,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.white,
                                                        BlendMode.colorBurn,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) {
                                                  return Shimmer.fromColors(
                                                    child: Card(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 300,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              header: GridTileBar(
                                                backgroundColor: Colors.black54,
                                                title: Container(),
                                                leading: (_locationProvider !=
                                                        null)
                                                    ? Text(
                                                        '${_distance.toStringAsFixed(2)} Km Away',
                                                        style:
                                                            GoogleFonts.gelasio(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(""),
                                                // Check whether is user is authenticated
                                                // If not show an empty button which when clicked
                                                // navigates to the signin page
                                                // Else a future builder which checks whethe the item
                                                // exists in the favorites collection
                                                // If true show a pink IconButton which when clicked
                                                // delete the item in favorites collection and changes
                                                // color to none
                                                // Else show an empty favorite button which when
                                                // clicked saves the item in the firestore collection
                                                // and color changes to pink
                                                trailing: (_authProvider.user !=
                                                        null)
                                                    ? StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'consumers')
                                                            .doc(_authProvider
                                                                .user!.uid)
                                                            .collection(
                                                                'favorites')
                                                            .doc(_items[item]
                                                                .itemId)
                                                            .snapshots(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snap) {
                                                          if (snap.hasData) {
                                                            if (snap.data !=
                                                                    null &&
                                                                snap.data!
                                                                    .exists) {
                                                              return IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .pink,
                                                                ),
                                                                onPressed: () {
                                                                  // Remove from firestore
                                                                  deleteFavorite(
                                                                    _authProvider
                                                                        .user!
                                                                        .uid,
                                                                    _items[item]
                                                                        .itemId!,
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              return IconButton(
                                                                icon: Icon(Icons
                                                                    .favorite_border_outlined),
                                                                onPressed: () {
                                                                  // Add to firestore
                                                                  createFavorite(
                                                                    _authProvider
                                                                        .user!
                                                                        .uid,
                                                                    _items[item]
                                                                        .itemId!,
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          }
                                                          return Container();
                                                        },
                                                      )
                                                    : IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .favorite_border_outlined,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  LoginScreen(
                                                                showCloseIcon:
                                                                    true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                              footer: GridTileBar(
                                                backgroundColor: Colors.black54,
                                                title: Text(
                                                  _items[item].title!,
                                                  style: GoogleFonts.gelasio(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "Ksh. ${_items[item].price}",
                                                  style: GoogleFonts.vidaloka(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return RecsShimmer();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
