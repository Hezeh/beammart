import 'dart:io';

import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/services/recommendations_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'category_view_all.dart';
import 'item_detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Get current location
    Provider.of<LocationProvider>(context, listen: false).init();
    Provider.of<DeviceInfoProvider>(context, listen: false).onInit();
    // Provider.of<ConnectivityStatus>(context);
  }

  @override
  Widget build(BuildContext context) {
    // final _connectionStatus = Provider.of<ConnectivityStatus>(context);
    final _locationProvider = Provider.of<LocationProvider>(context);
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
    return Scaffold(
      body: SafeArea(
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
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 5,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: InkWell(
                  onTap: () => searchUtil(context),
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: 10,
                    ),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 30,
                          ),
                          child: Icon(
                            Icons.search_outlined,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "What are you looking for?",
                              style: GoogleFonts.roboto(
                                color: Colors.pink,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Make a request to the recommendations api

            Container(
              child: FutureBuilder(
                future: getRecs(
                  lat: _locationProvider.currentLocation.latitude,
                  lon: _locationProvider.currentLocation.longitude,
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<ItemRecommendations> snapshot) {
                  if ((snapshot.hasData)) {
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
                                      categoryViewAllClickstream(
                                        deviceId,
                                        index,
                                        DateTime.now().toIso8601String(),
                                        snapshot.data!.recommendations![index]
                                            .category,
                                        _locationProvider
                                            .currentLocation.latitude,
                                        _locationProvider
                                            .currentLocation.longitude,
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CategoryViewAll(
                                            categoryName: snapshot
                                                .data!
                                                .recommendations![index]
                                                .category,
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
                                      categoryViewAllClickstream(
                                        deviceId,
                                        index,
                                        DateTime.now().toIso8601String(),
                                        snapshot.data!.recommendations![index]
                                            .category,
                                        _locationProvider
                                            .currentLocation.latitude,
                                        _locationProvider
                                            .currentLocation.longitude,
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CategoryViewAll(
                                            categoryName: snapshot
                                                .data!
                                                .recommendations![index]
                                                .category,
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
                                      final double _lat1 = _locationProvider
                                          .currentLocation.latitude;
                                      final double _lon1 = _locationProvider
                                          .currentLocation.longitude;
                                      final double _lat2 =
                                          _items[item].location!.lat!;
                                      final double _lon2 =
                                          _items[item].location!.lon!;
                                      final _distance = coordinateDistance(
                                          _lat1, _lon1, _lat2, _lon2);
                                      return InkWell(
                                        onTap: () {
                                          recommendationsItemClickstream(
                                            deviceId,
                                            _items[item].itemId,
                                            _items[item].businessId,
                                            index,
                                            DateTime.now().toIso8601String(),
                                            snapshot
                                                .data!
                                                .recommendations![index]
                                                .category,
                                            _locationProvider
                                                .currentLocation.latitude,
                                            _locationProvider
                                                .currentLocation.longitude,
                                            snapshot.data!.recsId,
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
                                                    _locationProvider
                                                        .currentLocation,
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
                                                backgroundColor: Colors.black12,
                                                leading: Text(
                                                  '${_distance.toStringAsFixed(2)} Km Away',
                                                  style: GoogleFonts.gelasio(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              footer: GridTileBar(
                                                backgroundColor: Colors.black12,
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
                    return Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                height: 400,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
