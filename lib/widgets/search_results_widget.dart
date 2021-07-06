import 'dart:io';

import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_results.dart';
import 'package:beammart/providers/ad_state.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/utils/closing_opening_time.dart';
import 'package:beammart/utils/is_business_open.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:beammart/widgets/search_result_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

final uuid = Uuid();

class SearchResults extends StatefulWidget {
  final AsyncSnapshot<ItemResults> snapshot;
  final String query;

  SearchResults(this.snapshot, this.query);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<Object>? itemList;

  @override
  void initState() {
    super.initState();
    setState(() {
      itemList = List.from(widget.snapshot.data!.items!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);

    adState.initialization.then((status) {
      setState(() {
        for (int i = itemList!.length; i < itemList!.length; i -= 1) {
          itemList!.insert(
            i,
            BannerAd(
              adUnitId: adState.bannerAdUnitId,
              size: AdSize.banner,
              request: AdRequest(),
              listener: adState.adListener,
            )..load(),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? _currentLocation =
        Provider.of<LocationProvider>(context).currentLoc;
    final deviceIdProvider =
        Provider.of<DeviceInfoProvider>(context).deviceInfo;
    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceIdProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceIdProvider!['identifierForVendor'];
    }
    return ListView.builder(
      itemCount: itemList!.length,
      itemBuilder: (context, index) {
        final String _uniqueViewId = uuid.v4();
        final String? itemId = widget.snapshot.data!.items![index].itemId;
        final String? title = widget.snapshot.data!.items![index].title;
        final int? price = widget.snapshot.data!.items![index].price;
        final String? description =
            widget.snapshot.data!.items![index].description;
        final List<String>? _imageUrl =
            widget.snapshot.data!.items![index].images;
        final double? _distance = widget.snapshot.data!.items![index].distance;
        final String? _phoneNumber =
            widget.snapshot.data!.items![index].phoneNumber;
        final Location _merchantLocation =
            widget.snapshot.data!.items![index].location!;
        final String? _merchantName =
            widget.snapshot.data!.items![index].businessName;
        final String? _merchantDescription =
            widget.snapshot.data!.items![index].businessDescription;
        final String? _merchantId = widget.snapshot.data!.items![index].userId;
        final String? _locationDescription =
            widget.snapshot.data!.items![index].locationDescription;
        final String? _dateJoined =
            widget.snapshot.data!.items![index].dateJoined;
        final String? _merchantPhotoUrl =
            widget.snapshot.data!.items![index].merchantPhotoUrl;
        final String _today = DateFormat('EEEE').format(DateTime.now());
        final String? _mondayOpeningTime =
            widget.snapshot.data!.items![index].mondayOpeningHours;
        final String? _mondayClosingTime =
            widget.snapshot.data!.items![index].mondayClosingHours;
        final String? _tuesdayOpeningTime =
            widget.snapshot.data!.items![index].tuesdayOpeningHours;
        final String? _tuesdayClosingTime =
            widget.snapshot.data!.items![index].tuesdayClosingHours;
        final String? _wednesdayOpeningTime =
            widget.snapshot.data!.items![index].wednesdayOpeningHours;
        final String? _wednesdayClosingTime =
            widget.snapshot.data!.items![index].wednesdayClosingHours;
        final String? _thursdayOpeningTime =
            widget.snapshot.data!.items![index].thursdayOpeningHours;
        final String? _thursdayClosingTime =
            widget.snapshot.data!.items![index].thursdayClosingHours;
        final String? _fridayOpeningTime =
            widget.snapshot.data!.items![index].fridayOpeningHours;
        final String? _fridayClosingTime =
            widget.snapshot.data!.items![index].fridayClosingHours;
        final String? _saturdayOpeningTime =
            widget.snapshot.data!.items![index].saturdayOpeningHours;
        final String? _saturdayClosingTime =
            widget.snapshot.data!.items![index].saturdayClosingHours;
        final String? _sundayOpeningTime =
            widget.snapshot.data!.items![index].sundayOpeningHours;
        final String? _sundayClosingTime =
            widget.snapshot.data!.items![index].sundayClosingHours;
        final bool? _isMondayOpen =
            widget.snapshot.data!.items![index].isMondayOpen;
        final bool? _isTuesdayOpen =
            widget.snapshot.data!.items![index].isTuesdayOpen;
        final bool? _isWednesdayOpen =
            widget.snapshot.data!.items![index].isWednesdayOpen;
        final bool? _isThursdayOpen =
            widget.snapshot.data!.items![index].isThursdayOpen;
        final bool? _isFridayOpen =
            widget.snapshot.data!.items![index].isFridayOpen;
        final bool? _isSaturdayOpen =
            widget.snapshot.data!.items![index].isSaturdayOpen;
        final bool? _isSundayOpen =
            widget.snapshot.data!.items![index].isSundayOpen;
        final String? _searchId = widget.snapshot.data!.searchId;
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
        final bool? _inStock = widget.snapshot.data!.items![index].inStock;

        if (itemList![index] is Item) {
          return VisibilityDetector(
            key: Key('SerpKey'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0.8) {
                final _timeStamp = DateTime.now().toIso8601String();
                // Get itemId
                final _itemId = itemId;
                if (_currentLocation != null) {
                  onItemView(
                    timeStamp: _timeStamp,
                    deviceId: deviceId,
                    itemId: _itemId,
                    viewId: _uniqueViewId,
                    percentage: info.visibleFraction,
                    merchantId: _merchantId,
                    query: widget.query,
                    lat: _currentLocation.latitude,
                    lon: _currentLocation.longitude,
                    index: index,
                    type: 'Search',
                  );
                } else {
                  onItemView(
                    timeStamp: _timeStamp,
                    deviceId: deviceId,
                    itemId: _itemId,
                    viewId: _uniqueViewId,
                    percentage: info.visibleFraction,
                    merchantId: _merchantId,
                    query: widget.query,
                    index: index,
                    type: 'Search',
                  );
                }
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
              currentLocation: (_currentLocation != null)
                  ? LatLng(
                      _currentLocation.latitude,
                      _currentLocation.longitude,
                    )
                  : null,
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
              searchQuery: widget.query,
            ),
          );
        } else {
          return Container(
            height: 50,
            child: AdWidget(
              ad: itemList![index] as BannerAd,
            ),
          );
        }
      },
    );
  }
}
