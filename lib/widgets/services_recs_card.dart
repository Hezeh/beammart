import 'dart:io';

import 'package:beammart/models/consumer_service_model.dart';
import 'package:beammart/models/services_recommendations.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/category_view_all.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ServicesRecommendationsResultCard extends StatelessWidget {
  final int index;
  final AsyncSnapshot<ServicesRecommendations> snapshot;
  const ServicesRecommendationsResultCard({
    Key? key,
    required this.index,
    required this.snapshot,
  }) : super(key: key);

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
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
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }

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
                  timeStamp: DateTime.now().toIso8601String(),
                  category: snapshot.data!.recommendations![index].category,
                  lat: (_locationProvider != null)
                      ? _locationProvider.latitude
                      : 0,
                  lon: (_locationProvider != null)
                      ? _locationProvider.longitude
                      : 0,
                  type: 'CategoryViewAllClick',
                  recsId: snapshot.data!.recsId,
                );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => CategoryViewAll(
                //       categoryName:
                //           snapshot.data!.recommendations![index].category,
                //     ),
                //   ),
                // );
              },
              child: Text(
                snapshot.data!.recommendations![index].category!,
                style: GoogleFonts.oxygen(
                  fontSize: 16,
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
                  timeStamp: DateTime.now().toIso8601String(),
                  category: snapshot.data!.recommendations![index].category,
                  lat: (_locationProvider != null)
                      ? _locationProvider.latitude
                      : 0,
                  lon: (_locationProvider != null)
                      ? _locationProvider.longitude
                      : 0,
                  type: 'CategoryViewAllClick',
                  recsId: snapshot.data!.recsId,
                );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (_) => CategoryViewAll(
                //       categoryName:
                //           snapshot.data!.recommendations![index].category,
                //     ),
                //   ),
                // );
              },
            ),
          ),
          Container(
            height: 250,
            color: Colors.grey,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  snapshot.data!.recommendations![index].services!.length,
              itemBuilder: (context, item) {
                String? _chatId;
                getChatId(String? merchantId) async {
                  if (_authProvider.user != null) {
                    final _chatSnapshot = await FirebaseFirestore.instance
                        .collection('chats')
                        .where(
                          'consumerId',
                          isEqualTo: _authProvider.user!.uid,
                        )
                        .where(
                          'businessId',
                          isEqualTo: merchantId,
                        )
                        .get();
                    if (_chatSnapshot.docs.isNotEmpty) {
                      _chatId = _chatSnapshot.docs.first.id;
                    }
                  } else {
                    _chatId = uuid.v4();
                  }
                }

                final _merchantId = snapshot
                    .data!.recommendations![index].services![item].businessId;

                getChatId(_merchantId);
                final List<ConsumerServiceModel> _items =
                    snapshot.data!.recommendations![index].services!;

                final double? _lat1 = (_locationProvider != null)
                    ? _locationProvider.latitude
                    : 0;
                final double? _lon1 = (_locationProvider != null)
                    ? _locationProvider.longitude
                    : 0;
                final double _lat2 = _items[item].location!.lat!;
                final double _lon2 = _items[item].location!.lon!;
                final _distance =
                    coordinateDistance(_lat1, _lon1, _lat2, _lon2);
                return VisibilityDetector(
                  key: Key('RecommendationsItem'),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction > 0.8) {
                      final _timeStamp = DateTime.now().toIso8601String();
                      // Get itemId
                      final _itemId = _items[item].serviceId;
                      final _merchantId = _items[item].businessId;
                      final String _uniqueViewId = uuid.v4();
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
                      final _itemId = _items[item].serviceId;
                      final _merchantId = _items[item].businessId;

                      clickstreamUtil(
                        deviceId: deviceId,
                        index: index,
                        timeStamp: DateTime.now().toIso8601String(),
                        category:
                            snapshot.data!.recommendations![index].category,
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
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => ItemDetail(
                      //       itemId: _items[item].serviceId,
                      //       imageUrl: _items[item].images,
                      //       itemTitle: _items[item].serviceName,
                      //       price: _items[item].servicePrice!.toInt(),
                      //       merchantLocation: LatLng(
                      //         _items[item].location!.lat!,
                      //         _items[item].location!.lon!,
                      //       ),
                      //       description: _items[item].serviceDescription,
                      //       dateJoined: _items[item].dateJoined,
                      //       merchantId: _items[item].businessId,
                      //       locationDescription:
                      //           _items[item].locationDescription,
                      //       merchantDescription:
                      //           _items[item].businessDescription,
                      //       merchantName: _items[item].businessName,
                      //       merchantPhotoUrl: _items[item].merchantPhotoUrl,
                      //       phoneNumber: _items[item].phoneNumber,
                      //       currentLocation: _locationProvider,
                      //       distance:
                      //           (_locationProvider != null) ? _distance : null,
                      //       isMondayOpen: _items[item].isMondayOpen,
                      //       isTuesdayOpen: _items[item].isTuesdayOpen,
                      //       isWednesdayOpen: _items[item].isWednesdayOpen,
                      //       isThursdayOpen: _items[item].isThursdayOpen,
                      //       isFridayOpen: _items[item].isFridayOpen,
                      //       isSaturdayOpen: _items[item].isSaturdayOpen,
                      //       isSundayOpen: _items[item].isSundayOpen,
                      //       mondayOpeningTime: _items[item].mondayOpeningHours,
                      //       mondayClosingTime: _items[item].mondayClosingHours,
                      //       tuesdayClosingTime:
                      //           _items[item].tuesdayClosingHours,
                      //       tuesdayOpeningTime:
                      //           _items[item].tuesdayOpeningHours,
                      //       wednesdayClosingTime:
                      //           _items[item].wednesdayClosingHours,
                      //       wednesdayOpeningTime:
                      //           _items[item].wednesdayOpeningHours,
                      //       thursdayClosingTime:
                      //           _items[item].thursdayClosingHours,
                      //       thursdayOpeningTime:
                      //           _items[item].thursdayOpeningHours,
                      //       fridayClosingTime: _items[item].fridayClosingHours,
                      //       fridayOpeningTime: _items[item].fridayOpeningHours,
                      //       saturdayClosingTime:
                      //           _items[item].saturdayClosingHours,
                      //       saturdayOpeningTime:
                      //           _items[item].saturdayOpeningHours,
                      //       sundayClosingTime: _items[item].sundayClosingHours,
                      //       sundayOpeningTime: _items[item].sundayOpeningHours,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        // height: 200,
                        width: 350,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                // height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: GridTile(
                                    // child: Text("${_items[index].serviceName}"),
                                    child: SizedBox.shrink(),
                                    header: GridTileBar(
                                      backgroundColor: Colors.black54,
                                      title: Container(),
                                      leading: (_locationProvider != null)
                                          ? Text(
                                              '${_distance.toStringAsFixed(2)} Km Away',
                                              style: GoogleFonts.gelasio(
                                                color: Colors.white,
                                                // fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(""),
                                      trailing: (_authProvider.user != null)
                                          ? StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('consumers')
                                                  .doc(_authProvider.user!.uid)
                                                  .collection('favorites')
                                                  .doc(_items[item].serviceId)
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snap) {
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
                                                          _authProvider
                                                              .user!.uid,
                                                          _items[item]
                                                              .serviceId!,
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
                                                              .user!.uid,
                                                          _items[item]
                                                              .serviceId!,
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
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                width: 200,
                                child: Center(
                                  child: Text(
                                    _items[item].serviceName!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.gelasio(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Pricing Type: ${_items[item].servicePriceType}",
                                  style: GoogleFonts.vidaloka(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "Ksh. ${_items[item].servicePrice}",
                                  style: GoogleFonts.vidaloka(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                // width: 200,
                                child: Text(
                                  "Offered By: ${_items[item].businessName}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.gelasio(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                      width: 150,
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _makePhoneCall(
                                            'tel:${snapshot.data!.recommendations![index].services![item].phoneNumber}');
                                      },
                                      icon: Icon(
                                        Icons.call_outlined,
                                      ),
                                      label: Text("Call"),
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                      width: 150,
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (_authProvider.user != null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ChatScreen(
                                                chatId: _chatId,
                                                businessName: snapshot
                                                    .data!
                                                    .recommendations![index]
                                                    .services![item]
                                                    .businessName,
                                                businessId: snapshot
                                                    .data!
                                                    .recommendations![index]
                                                    .services![item]
                                                    .businessId,
                                                businessPhotoUrl: snapshot
                                                    .data!
                                                    .recommendations![index]
                                                    .services![item]
                                                    .merchantPhotoUrl,
                                                consumerDisplayName:
                                                    _authProvider
                                                        .user!.displayName,
                                                consumerId:
                                                    _authProvider.user!.uid,
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
                                      icon: Icon(
                                        Icons.chat_bubble_outline_outlined,
                                      ),
                                      label: Text("Chat"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  }
}
