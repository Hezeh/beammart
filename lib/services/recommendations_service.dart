import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

Future<ItemRecommendations> getRecs(BuildContext context,
    {double? lat, double? lon}) async {
  final LatLng? _loc = Provider.of<LocationProvider>(context).currentLoc;
  final _collectionRef = FirebaseFirestore.instance.collection('items');

  ItemRecommendations? _itemRecs = ItemRecommendations();
  List<Recommendations>? _recsList = [];
  List<dynamic>? _categories = [];

  final _docs = await _collectionRef.get();

  if (_docs.size != 0) {
    for (var i = 0; i < _docs.size; i++) {
      final _docCategory = _docs.docs[i].data()['category'];
      if (!_categories.contains(_docCategory)) {
        _categories.add(_docCategory);
      }
    }
  }

  for (var i = 0; i < _categories.length; i++) {
    List<Item>? _recs = [];
    if (_docs.size != 0) {
      for (var x = 0; x < _docs.size; x++) {
        final _docCategory = _docs.docs[x].data()['category'];
        if (_docCategory == _categories[i]) {
          final _data = _docs.docs[x].data();
          final _location = Location(
            lat: _data['location'].latitude,
            lon: _data['location'].longitude,
          );
          final _formattedItem = Item(
            itemId: _data['itemId'],
            userId: _data['userId'],
            images: _data['imageUrls'],
            title: _data['title'],
            description: _data['description'],
            price: _data['price'],
            location: _location,
            locationDescription: _data['locationDescription'],
            businessName: _data['businessName'],
            businessDescription: _data['businessDescription'],
            phoneNumber: _data['phoneNumber'],
            mondayOpeningHours: _data['mondayOpeningHours'],
            mondayClosingHours: _data['mondayClosingHours'],
            tuesdayOpeningHours: _data['tuesdayOpeningHours'],
            tuesdayClosingHours: _data['tuesdayClosingHours'],
            wednesdayOpeningHours: _data['wednesdayOpeningHours'],
            wednesdayClosingHours: _data['wednesdayClosingHours'],
            thursdayOpeningHours: _data['thursdayOpeningHours'],
            thursdayClosingHours: _data['thursdayClosingHours'],
            fridayOpeningHours: _data['fridayOpeningHours'],
            fridayClosingHours: _data['fridayClosingHours'],
            saturdayOpeningHours: _data['saturdayOpeningHours'],
            saturdayClosingHours: _data['saturdayClosingHours'],
            sundayOpeningHours: _data['sundayOpeningHours'],
            sundayClosingHours: _data['sundayClosingHours'],
            distance: _data['distance'],
            businessId: _data['userId'],
            dateJoined: _data['dateJoined'],
            dateAdded: _data['dateAdded'],
            merchantPhotoUrl: _data['businessProfilePhoto'],
            inStock: _data['inStock'],
            isMondayOpen: _data['isMondayOpen'],
            isTuesdayOpen: _data['isTuesdayOpen'],
            isWednesdayOpen: _data['isWednesdayOpen'],
            isThursdayOpen: _data['isThursdayOpen'],
            isFridayOpen: _data['isFridayOpen'],
            isSaturdayOpen: _data['isSaturdayOpen'],
            isSundayOpen: _data['isSundayOpen'],
            category: _data['category'],
            subCategory: _data['subCategory'],
          );
          _recs.add(_formattedItem);
        }
      }
    }
    final _recommendations =
        Recommendations(category: _categories[i], items: _recs).toJson();
    _recsList.add(Recommendations.fromJson(_recommendations));
  }

  _itemRecs = ItemRecommendations(recsId: '1234', recommendations: _recsList);

  if (_itemRecs != null) {
    final _resp = _itemRecs;
    return _resp;
  } else {
    return ItemRecommendations();
  }

  // if (_loc != null) {
  //   final response = await http.get(
  //     Uri(
  //         scheme: 'https',
  //         host: 'api.beammart.app',
  //         path: 'recs',
  //         query: 'lat=${_loc.latitude}&lon=${_loc.longitude}'),
  //   );
  //   final jsonResponse =
  //       ItemRecommendations.fromJson(json.decode(response.body));
  //   if (response.statusCode == 200) {
  //     return jsonResponse;
  //   }
  //   return ItemRecommendations();
  // } else {
  //   print("Get Recs");
  //   final response = await http.get(
  //     Uri(
  //       scheme: 'https',
  //       host: 'api.beammart.app',
  //       path: 'recs',
  //     ),
  //   );
  //   final jsonResponse =
  //       ItemRecommendations.fromJson(json.decode(response.body));
  //   if (response.statusCode == 200) {
  //     return jsonResponse;
  //   }
  //   return ItemRecommendations();
  // }
}
