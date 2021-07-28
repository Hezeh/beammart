import 'dart:io';

import 'package:beammart/models/category_items.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/services/category_view_all_service.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:uuid/uuid.dart';

import 'login_screen.dart';

final uuid = Uuid();

class CategoryViewAll extends StatelessWidget {
  final String? categoryName;

  const CategoryViewAll({
    Key? key,
    this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _currentLocation = Provider.of<LatLng?>(context);
    final _currentLocation = Provider.of<LocationProvider>(context).currentLoc;
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$categoryName',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => searchUtil(context),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 1,
          left: 1,
          right: 1,
        ),
        child: FutureBuilder(
          future: getCategoryItems(categoryName),
          builder:
              (BuildContext context, AsyncSnapshot<CategoryItems> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.hasData) {
              if (snapshot.data!.items!.length == 0) {
                return Center(
                  child: Text("No items in this category"),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  childAspectRatio: .7,
                ),
                itemCount: snapshot.data!.items!.length,
                itemBuilder: (context, index) {
                  double? _lat1 = 0;
                  double? _lon1 = 0;
                  if (_currentLocation != null) {
                    _lat1 = _currentLocation.latitude;
                    _lon1 = _currentLocation.longitude;
                  }
                  final double? _lat2 =
                      snapshot.data!.items![index].location!.lat!;
                  final double? _lon2 =
                      snapshot.data!.items![index].location!.lon!;
                  final _distance =
                      coordinateDistance(_lat1, _lon1, _lat2, _lon2);
                  return VisibilityDetector(
                    key: Key('CategoryViewAll'),
                    onVisibilityChanged: (info) {
                      if (info.visibleFraction > 0.8) {
                        final _timeStamp = DateTime.now().toIso8601String();
                        // Get itemId
                        final _itemId = snapshot.data!.items![index].itemId;
                        final _merchantId =
                            snapshot.data!.items![index].businessId;
                        final String _uniqueViewId = uuid.v4();
                        if (_currentLocation != null) {
                          onItemView(
                            timeStamp: _timeStamp,
                            deviceId: deviceId,
                            itemId: _itemId,
                            viewId: _uniqueViewId,
                            percentage: info.visibleFraction,
                            merchantId: _merchantId,
                            lat: _currentLocation.latitude,
                            lon: _currentLocation.longitude,
                            index: index,
                            type: 'CategoryViewAll',
                          );
                        }
                      }
                    },
                    child: InkWell(
                      onTap: () {
                        if (_currentLocation != null) {
                          clickstreamUtil(
                            deviceId: deviceId,
                            index: index,
                            timeStamp: DateTime.now().toIso8601String(),
                            category: categoryName,
                            lat: _currentLocation.latitude,
                            lon: _currentLocation.longitude,
                            type: 'CategoryItemClick',
                            itemId: snapshot.data!.items![index].itemId,
                            merchantId: snapshot.data!.items![index].businessId,
                          );
                        }

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ItemDetail(
                              itemTitle: snapshot.data!.items![index].title,
                              itemId: snapshot.data!.items![index].itemId,
                              description:
                                  snapshot.data!.items![index].description,
                              price: snapshot.data!.items![index].price,
                              isMondayOpen:
                                  snapshot.data!.items![index].isMondayOpen,
                              isTuesdayOpen:
                                  snapshot.data!.items![index].isTuesdayOpen,
                              isWednesdayOpen:
                                  snapshot.data!.items![index].isWednesdayOpen,
                              isThursdayOpen:
                                  snapshot.data!.items![index].isThursdayOpen,
                              isFridayOpen:
                                  snapshot.data!.items![index].isFridayOpen,
                              isSaturdayOpen:
                                  snapshot.data!.items![index].isSaturdayOpen,
                              isSundayOpen:
                                  snapshot.data!.items![index].isSundayOpen,
                              mondayOpeningTime: snapshot
                                  .data!.items![index].mondayOpeningHours,
                              mondayClosingTime: snapshot
                                  .data!.items![index].mondayClosingHours,
                              tuesdayOpeningTime: snapshot
                                  .data!.items![index].tuesdayOpeningHours,
                              tuesdayClosingTime: snapshot
                                  .data!.items![index].tuesdayClosingHours,
                              wednesdayOpeningTime: snapshot
                                  .data!.items![index].wednesdayOpeningHours,
                              wednesdayClosingTime: snapshot
                                  .data!.items![index].wednesdayClosingHours,
                              thursdayClosingTime: snapshot
                                  .data!.items![index].thursdayClosingHours,
                              thursdayOpeningTime: snapshot
                                  .data!.items![index].thursdayOpeningHours,
                              fridayClosingTime: snapshot
                                  .data!.items![index].fridayClosingHours,
                              fridayOpeningTime: snapshot
                                  .data!.items![index].fridayOpeningHours,
                              saturdayClosingTime: snapshot
                                  .data!.items![index].saturdayClosingHours,
                              saturdayOpeningTime: snapshot
                                  .data!.items![index].saturdayOpeningHours,
                              sundayClosingTime: snapshot
                                  .data!.items![index].sundayClosingHours,
                              sundayOpeningTime: snapshot
                                  .data!.items![index].sundayOpeningHours,
                              dateJoined:
                                  snapshot.data!.items![index].dateJoined,
                              imageUrl: snapshot.data!.items![index].images,
                              merchantDescription: snapshot
                                  .data!.items![index].businessDescription,
                              locationDescription: snapshot
                                  .data!.items![index].locationDescription,
                              merchantId:
                                  snapshot.data!.items![index].businessId,
                              phoneNumber:
                                  snapshot.data!.items![index].phoneNumber,
                              merchantName:
                                  snapshot.data!.items![index].businessName,
                              merchantPhotoUrl:
                                  snapshot.data!.items![index].merchantPhotoUrl,
                              merchantLocation: LatLng(
                                  snapshot.data!.items![index].location!.lat!,
                                  snapshot.data!.items![index].location!.lon!),
                              currentLocation: (_currentLocation != null)
                                  ? LatLng(
                                      _currentLocation.latitude,
                                      _currentLocation.longitude,
                                    )
                                  : null,
                              distance: (_currentLocation != null) ? _distance : null,

                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GridTile(
                            header: GridTileBar(
                              backgroundColor: Colors.black12,
                              title: Container(),
                              trailing: (_authProvider.user != null)
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('consumers')
                                          .doc(_authProvider.user!.uid)
                                          .collection('favorites')
                                          .doc(snapshot
                                              .data!.items![index].itemId)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data != null &&
                                              snapshot.data!.exists) {
                                            return IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.pink,
                                              ),
                                              onPressed: () {
                                                // Remove from firestore
                                                deleteFavorite(
                                                  _authProvider.user!.uid,
                                                  snapshot.data!.id,
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
                                                  _authProvider.user!.uid,
                                                  snapshot.data!.id,
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
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!.items![index].images!.first.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 300,
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
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  child: Card(
                                    child: Container(
                                      width: double.infinity,
                                      height: 400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            footer: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: GridTileBar(
                                backgroundColor: Colors.black26,
                                title:
                                    Text(snapshot.data!.items![index].title!),
                                trailing: Text(
                                  'Ksh.${snapshot.data!.items![index].price.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return LinearProgressIndicator();
          },
        ),
      ),
    );
  }
}
