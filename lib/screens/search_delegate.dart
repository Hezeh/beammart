import 'dart:io';

import 'package:beammart/models/item_results.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/services/past_searches_service.dart';
import 'package:beammart/services/search_api_wrapper.dart';
import 'package:beammart/services/search_history_service.dart';
import 'package:beammart/widgets/search_results_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'search.dart' as customSearch;

final uuid = Uuid();

class SearchScreen extends customSearch.SearchDelegate {
  Banner? banner;
  SearchScreen() : super();
  // geolocation.Location locationService = new geolocation.Location();

  // final ItemSearchService searchService;
  // final SearchAPIWrapper searchAPIWrapper;

  // SearchScreen({this.searchService, this.searchAPIWrapper, });

  // Future<geolocation.LocationData> getCurrentLocation() async {
  //   final geolocation.LocationData loc = await locationService.getLocation();
  //   return loc;
  // }

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
  PreferredSizeWidget? buildBottom(BuildContext context) {
    // TODO: implement buildBottom
    return super.buildBottom(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    // final LatLng? _currentLocation =
    //     Provider.of<LatLng?>(context, listen: false);
    final LatLng? _currentLocation =
        Provider.of<LocationProvider>(context).currentLoc;
    final deviceIdProvider =
        Provider.of<DeviceInfoProvider>(context).deviceInfo;
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    if (query.isEmpty) {
      return Container();
    }

    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceIdProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceIdProvider!['identifierForVendor'];
    }

    if (_authProvider.user != null) {
      if (_currentLocation != null) {
        postPastSearches(
            userId: _authProvider.user!.uid,
            deviceId: deviceId,
            query: query,
            lat: _currentLocation.latitude,
            lon: _currentLocation.longitude,
            timestamp: DateTime.now().toIso8601String());
      } else {
        postPastSearches(
            userId: _authProvider.user!.uid,
            deviceId: deviceId,
            query: query,
            timestamp: DateTime.now().toIso8601String());
      }
    } else {
      if (_currentLocation != null) {
        postPastSearches(
            deviceId: deviceId,
            query: query,
            lat: _currentLocation.latitude,
            lon: _currentLocation.longitude,
            timestamp: DateTime.now().toIso8601String());
      } else {
        postPastSearches(
            deviceId: deviceId,
            query: query,
            timestamp: DateTime.now().toIso8601String());
      }
    }
    final Future<ItemResults> results =
        SearchAPIWrapper().searchItems(query, _currentLocation);
    // getResults() async {
    //   final ItemResults results =
    //       await SearchAPIWrapper().searchItems(query, _currentLocation);
    //   return results;
    // }

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
            return SearchResults(snapshot, query);
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
