import 'dart:io';

import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_results.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/services/search_api_wrapper.dart';
import 'package:beammart/services/search_history_service.dart';
import 'package:beammart/utils/closing_opening_time.dart';
import 'package:beammart/utils/is_business_open.dart';
import 'package:beammart/widgets/search_result_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart' as geolocation;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'search.dart' as customSearch;

final uuid = Uuid();

class SearchScreen extends customSearch.SearchDelegate {
  SearchScreen() : super();
  geolocation.Location locationService = new geolocation.Location();

  // final ItemSearchService searchService;
  // final SearchAPIWrapper searchAPIWrapper;

  // SearchScreen({this.searchService, this.searchAPIWrapper, });

  Future<geolocation.LocationData> getCurrentLocation() async {
    final geolocation.LocationData loc = await locationService.getLocation();
    return loc;
  }

  Key singleItemKey = Key('singleItemKey');

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final LatLng _currentLocation =
        Provider.of<LocationProvider>(context).currentLocation;
    final deviceIdProvider =
        Provider.of<DeviceInfoProvider>(context).deviceInfo;
    if (query.isEmpty) {
      // TODO: If empty show a list of recent searches
      return Container();
    }

    // if (Platform.isAndroid) {
    //   FirestoreService().saveSearches(deviceIdProvider!['androidId'], query);
    // } else if (Platform.isIOS) {
    //   FirestoreService().saveSearches(deviceIdProvider!['identifierForVendor'], query);
    // }
    final Future<ItemResults> results =
        SearchAPIWrapper().searchItems(query, _currentLocation);
    // getResults() async {
    //   final ItemResults results =
    //       await SearchAPIWrapper().searchItems(query, _currentLocation);
    //   return results;
    // }
    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceIdProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceIdProvider!['identifierForVendor'];
    }

    return FutureBuilder(
      future: results,
      builder: (context, AsyncSnapshot<ItemResults> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            backgroundColor: Colors.pink,
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.items != null &&
              snapshot.data!.items!.length != 0) {
            return Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                ListView.builder(
                  itemCount: snapshot.data!.items!.length,
                  itemBuilder: (context, index) {
                    final String _uniqueViewId = uuid.v4();
                    final String? itemId = snapshot.data!.items![index].itemId;
                    final String? title = snapshot.data!.items![index].title;
                    final int? price = snapshot.data!.items![index].price;
                    final String? description =
                        snapshot.data!.items![index].description;
                    final List<String>? _imageUrl =
                        snapshot.data!.items![index].images;
                    final double? _distance =
                        snapshot.data!.items![index].distance;
                    final String? _phoneNumber =
                        snapshot.data!.items![index].phoneNumber;
                    final Location _merchantLocation =
                        snapshot.data!.items![index].location!;
                    final String? _merchantName =
                        snapshot.data!.items![index].businessName;
                    final String? _merchantDescription =
                        snapshot.data!.items![index].businessDescription;
                    final String? _merchantId =
                        snapshot.data!.items![index].userId;
                    final String? _locationDescription =
                        snapshot.data!.items![index].locationDescription;
                    final String? _dateJoined =
                        snapshot.data!.items![index].dateJoined;
                    final String? _merchantPhotoUrl =
                        snapshot.data!.items![index].merchantPhotoUrl;
                    final String _today =
                        DateFormat('EEEE').format(DateTime.now());
                    final String? _mondayOpeningTime =
                        snapshot.data!.items![index].mondayOpeningHours;
                    final String? _mondayClosingTime =
                        snapshot.data!.items![index].mondayClosingHours;
                    final String? _tuesdayOpeningTime =
                        snapshot.data!.items![index].tuesdayOpeningHours;
                    final String? _tuesdayClosingTime =
                        snapshot.data!.items![index].tuesdayClosingHours;
                    final String? _wednesdayOpeningTime =
                        snapshot.data!.items![index].wednesdayOpeningHours;
                    final String? _wednesdayClosingTime =
                        snapshot.data!.items![index].wednesdayClosingHours;
                    final String? _thursdayOpeningTime =
                        snapshot.data!.items![index].thursdayOpeningHours;
                    final String? _thursdayClosingTime =
                        snapshot.data!.items![index].thursdayClosingHours;
                    final String? _fridayOpeningTime =
                        snapshot.data!.items![index].fridayOpeningHours;
                    final String? _fridayClosingTime =
                        snapshot.data!.items![index].fridayClosingHours;
                    final String? _saturdayOpeningTime =
                        snapshot.data!.items![index].saturdayOpeningHours;
                    final String? _saturdayClosingTime =
                        snapshot.data!.items![index].saturdayClosingHours;
                    final String? _sundayOpeningTime =
                        snapshot.data!.items![index].sundayOpeningHours;
                    final String? _sundayClosingTime =
                        snapshot.data!.items![index].sundayClosingHours;
                    final bool? _isMondayOpen =
                        snapshot.data!.items![index].isMondayOpen;
                    final bool? _isTuesdayOpen =
                        snapshot.data!.items![index].isTuesdayOpen;
                    final bool? _isWednesdayOpen =
                        snapshot.data!.items![index].isWednesdayOpen;
                    final bool? _isThursdayOpen =
                        snapshot.data!.items![index].isThursdayOpen;
                    final bool? _isFridayOpen =
                        snapshot.data!.items![index].isFridayOpen;
                    final bool? _isSaturdayOpen =
                        snapshot.data!.items![index].isSaturdayOpen;
                    final bool? _isSundayOpen =
                        snapshot.data!.items![index].isSundayOpen;
                    final String? _searchId = snapshot.data!.searchId;
                    // Is the business Open;
                    final bool _isBusinessOpen = isBusinessOpen(
                      isMondayOpen: _isMondayOpen,
                      isTuesdayOpen: _isTuesdayOpen,
                      isWednesdayOpen: _isWednesdayOpen,
                      isThursdayOpen: _isThursdayOpen,
                      isFridayOpen: _isFridayOpen,
                      isSaturdayOpen: _isSaturdayOpen,
                      isSundayOpen: _isSundayOpen,
                      today: _today,
                      mondayOpeningTime: _mondayOpeningTime,
                      mondayClosingTime: _mondayClosingTime,
                      tuesdayOpeningTime: _tuesdayOpeningTime,
                      tuesdayClosingTime: _tuesdayClosingTime,
                      wednesdayOpeningTime: _tuesdayOpeningTime,
                      wednesdayClosingTime: _wednesdayClosingTime,
                      thursdayOpeningTime: _thursdayOpeningTime,
                      thursdayClosingTime: _thursdayClosingTime,
                      fridayOpeningTime: _fridayOpeningTime,
                      fridayClosingTime: _fridayClosingTime,
                      saturdayOpeningTime: _saturdayOpeningTime,
                      saturdayClosingTime: _saturdayClosingTime,
                      sundayOpeningTime: _sundayOpeningTime,
                      sundayClosingTime: _sundayClosingTime,
                    );
                    // Closing Time & Opening Time
                    final String _timeToOpenOrClose = closingOpeningTimeUtil(
                      mondayIsOpen: _isMondayOpen,
                      tuesdayIsOpen: _isTuesdayOpen,
                      wednesdayIsOpen: _isWednesdayOpen,
                      thursdayIsOpen: _isThursdayOpen,
                      fridayIsOpen: _isFridayOpen,
                      saturdayIsOpen: _isSaturdayOpen,
                      sundayIsOpen: _isSundayOpen,
                      isOpen: _isBusinessOpen,
                      today: _today,
                      mondayOpeningTime: _mondayOpeningTime,
                      mondayClosingTime: _mondayClosingTime,
                      tuesdayOpeningTime: _tuesdayOpeningTime,
                      tuesdayClosingTime: _tuesdayClosingTime,
                      wednesdayOpeningTime: _wednesdayOpeningTime,
                      wednesdayClosingTime: _wednesdayClosingTime,
                      thursdayOpeningTime: _thursdayOpeningTime,
                      thursdayClosingTime: _thursdayClosingTime,
                      fridayOpeningTime: _fridayOpeningTime,
                      fridayClosingTime: _fridayClosingTime,
                      saturdayOpeningTime: _saturdayClosingTime,
                      saturdayClosingTime: _saturdayClosingTime,
                      sundayOpeningTime: _sundayOpeningTime,
                      sundayClosingTime: _sundayClosingTime,
                    );

                    // Is the item inStock;
                    final bool? _inStock = snapshot.data!.items![index].inStock;

                    return VisibilityDetector(
                      key: singleItemKey,
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.8) {
                          final _timeStamp = DateTime.now().toIso8601String();
                          // Get itemId
                          final _itemId = itemId;
                          onItemView(
                            timeStamp: _timeStamp,
                            deviceId: deviceId,
                            itemId: _itemId,
                            viewId: _uniqueViewId,
                            percentage: info.visibleFraction,
                            merchantId: _merchantId,
                            query: query,
                            lat: _currentLocation.latitude,
                            lon: _currentLocation.longitude,
                            index: index,
                            type: 'Search',
                          );
                        }
                      },
                      child: SearchResultCard(
                        searchId: _searchId,
                        deviceId: deviceId,
                        index: index,
                        itemId: itemId,
                        title: title,
                        description: description,
                        price: price,
                        imageUrl: _imageUrl,
                        distance: _distance,
                        phoneNumber: _phoneNumber,
                        merchantLocation: LatLng(
                          _merchantLocation.lat!,
                          _merchantLocation.lon!,
                        ),
                        currentLocation: LatLng(
                          _currentLocation.latitude,
                          _currentLocation.longitude,
                        ),
                        locationDescription: _locationDescription,
                        dateJoined: _dateJoined,
                        merchantDescription: _merchantDescription,
                        merchantId: _merchantId,
                        merchantName: _merchantName,
                        merchantPhotoUrl: _merchantPhotoUrl,
                        inStock: _inStock,
                        isOpen: _isBusinessOpen,
                        openingOrClosingTime: _timeToOpenOrClose,
                        isMondayOpen: _isMondayOpen,
                        isTuesdayOpen: _isTuesdayOpen,
                        isWednesdayOpen: _isWednesdayOpen,
                        isThursdayOpen: _isThursdayOpen,
                        isFridayOpen: _isFridayOpen,
                        isSaturdayOpen: _isSaturdayOpen,
                        isSundayOpen: _isSundayOpen,
                        mondayOpeningTime: _mondayOpeningTime,
                        mondayClosingTime: _mondayClosingTime,
                        tuesdayOpeningTime: _tuesdayOpeningTime,
                        tuesdayClosingTime: _tuesdayClosingTime,
                        wednesdayOpeningTime: _wednesdayOpeningTime,
                        wednesdayClosingTime: _wednesdayClosingTime,
                        thursdayOpeningTime: _thursdayOpeningTime,
                        thursdayClosingTime: _thursdayClosingTime,
                        fridayOpeningTime: _fridayOpeningTime,
                        fridayClosingTime: _fridayClosingTime,
                        saturdayOpeningTime: _saturdayOpeningTime,
                        saturdayClosingTime: _saturdayClosingTime,
                        sundayClosingTime: _sundayClosingTime,
                        sundayOpeningTime: _sundayOpeningTime,
                        searchQuery: query,
                      ),
                    );
                  },
                ),
              ],
            );
          }
        }
        return Center(
          child: Text(
            'No results found',
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final deviceProvider = Provider.of<DeviceInfoProvider>(context);
    if (Platform.isAndroid) {
      if (query.isEmpty) {
        return StreamBuilder(
          stream: SearchHistoryService()
              .getPastSearches(deviceProvider.deviceInfo!['androidId']),
          builder: (context, snapshot) {
            return Container(
                // child: Text('Hello Android'),
                );
          },
        );
      }
    } else if (Platform.isIOS) {
      if (query.isEmpty) {
        return StreamBuilder(
          stream: SearchHistoryService().getPastSearches(
              deviceProvider.deviceInfo!['identifierForVendor']),
          builder: (context, snapshot) {
            return Container(
                // child: Text('Hello IOS'),
                );
          },
        );
      }
    }
    return Container();
  }
}
