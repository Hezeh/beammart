import 'dart:io';

import 'package:beammart/models/category_items.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/services/category_view_all_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/search_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryViewAll extends StatelessWidget {
  final String? categoryName;

  const CategoryViewAll({
    Key? key,
    this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentLocation = Provider.of<LocationProvider>(context);
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
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

            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  childAspectRatio: .7,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.items!.length,
                itemBuilder: (context, index) {
                  final double _lat1 =
                      _currentLocation.currentLocation.latitude;
                  final double _lon1 =
                      _currentLocation.currentLocation.longitude;
                  final double _lat2 = snapshot.data!.items![index].location!.lat!;
                  final double _lon2 = snapshot.data!.items![index].location!.lon!;
                  final _distance =
                      coordinateDistance(_lat1, _lon1, _lat2, _lon2);
                  return InkWell(
                    onTap: () {
                      categoryItemClickstream(
                        deviceId,
                        snapshot.data!.items![index].itemId,
                        snapshot.data!.items![index].businessId,
                        index,
                        DateTime.now().toIso8601String(),
                        categoryName,
                        _currentLocation.currentLocation.latitude,
                        _currentLocation.currentLocation.longitude,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ItemDetail(
                            itemTitle: snapshot.data!.items![index].title,
                            itemId: snapshot.data!.items![index].itemId,
                            description: snapshot.data!.items![index].description,
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
                            mondayOpeningTime:
                                snapshot.data!.items![index].mondayOpeningHours,
                            mondayClosingTime:
                                snapshot.data!.items![index].mondayClosingHours,
                            tuesdayOpeningTime:
                                snapshot.data!.items![index].tuesdayOpeningHours,
                            tuesdayClosingTime:
                                snapshot.data!.items![index].tuesdayClosingHours,
                            wednesdayOpeningTime: snapshot
                                .data!.items![index].wednesdayOpeningHours,
                            wednesdayClosingTime: snapshot
                                .data!.items![index].wednesdayClosingHours,
                            thursdayClosingTime:
                                snapshot.data!.items![index].thursdayClosingHours,
                            thursdayOpeningTime:
                                snapshot.data!.items![index].thursdayOpeningHours,
                            fridayClosingTime:
                                snapshot.data!.items![index].fridayClosingHours,
                            fridayOpeningTime:
                                snapshot.data!.items![index].fridayOpeningHours,
                            saturdayClosingTime:
                                snapshot.data!.items![index].saturdayClosingHours,
                            saturdayOpeningTime:
                                snapshot.data!.items![index].saturdayOpeningHours,
                            sundayClosingTime:
                                snapshot.data!.items![index].sundayClosingHours,
                            sundayOpeningTime:
                                snapshot.data!.items![index].sundayOpeningHours,
                            dateJoined: snapshot.data!.items![index].dateJoined,
                            imageUrl: snapshot.data!.items![index].images,
                            merchantDescription:
                                snapshot.data!.items![index].businessDescription,
                            locationDescription:
                                snapshot.data!.items![index].locationDescription,
                            merchantId: snapshot.data!.items![index].businessId,
                            phoneNumber: snapshot.data!.items![index].phoneNumber,
                            merchantName:
                                snapshot.data!.items![index].businessName,
                            merchantPhotoUrl:
                                snapshot.data!.items![index].merchantPhotoUrl,
                            merchantLocation: LatLng(
                                snapshot.data!.items![index].location!.lat!,
                                snapshot.data!.items![index].location!.lon!),
                            currentLocation: LatLng(
                              _currentLocation.currentLocation.latitude,
                              _currentLocation.currentLocation.longitude,
                            ),
                            distance: _distance,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GridTile(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.items![index].images!.first,
                          imageBuilder: (context, imageProvider) => Container(
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
                            title: Text(snapshot.data!.items![index].title!),
                            trailing: Text(
                              snapshot.data!.items![index].price.toString(),
                              style: TextStyle(
                                color: Colors.white,
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