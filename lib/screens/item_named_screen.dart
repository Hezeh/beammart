import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/models/profile.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/arguments/item_named_screen_arguments.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ItemNamedScreen extends StatefulWidget {
  const ItemNamedScreen({Key? key}) : super(key: key);

  @override
  State<ItemNamedScreen> createState() => _ItemNamedScreenState();
}

class _ItemNamedScreenState extends State<ItemNamedScreen> {
  bool shopLoading = true;
  bool itemLoading = true;
  Profile? _profile;
  MerchantItem? _item;

  @override
  Widget build(BuildContext context) {
    final _locationProvider = Provider.of<LocationProvider>(context);
    final _currentLocation = _locationProvider.currentLoc;
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ItemNamedScreenArguments.
    final args =
        ModalRoute.of(context)!.settings.arguments as ItemNamedScreenArguments;
    final _shopId = args.shopId;
    final _itemId = args.itemId;
    final _itemName = args.itemName;
    final _itemRef = args.ref;

    getShopDetails() async {
      if (_shopId != null) {
        final _shopDbRef =
            FirebaseFirestore.instance.collection('profile').doc(_shopId);
        final _shopDoc = await _shopDbRef.get();
        if (_shopDoc.exists) {
          // Get the document data
          if (_shopDoc.data() != null) {
            final _shopDocData = Profile.fromJson(_shopDoc.data()!);
            setState(() {
              _profile = _shopDocData;
              shopLoading = false;
            });
          }
        }
      }
    }

    getItemDetails() async {
      if (_shopId != null && _itemId != null) {
        final _itemDbRef = FirebaseFirestore.instance
            .collection('profile')
            .doc(_shopId)
            .collection('items')
            .doc(_itemId);
        final _itemDoc = await _itemDbRef.get();
        if (_itemDoc.exists) {
          // Get the document data
          if (_itemDoc.data() != null) {
            final _itemDocData = MerchantItem.fromJson(_itemDoc.data()!);
            setState(() {
              _item = _itemDocData;
              itemLoading = false;
            });
          }
        }
      }
    }

    getShopDetails();
    getItemDetails();

    if (shopLoading || itemLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ItemDetail(
      imageUrl: _item!.images,
      itemId: _item!.itemId,
      description: _item!.description,
      merchantId: _profile!.storeId,
      merchantName: _profile!.businessName,
      merchantDescription: _profile!.businessDescription,
      isMondayOpen: _profile!.isMondayOpen,
      isTuesdayOpen: _profile!.isTuesdayOpen,
      isWednesdayOpen: _profile!.isWednesdayOpen,
      isThursdayOpen: _profile!.isThursdayOpen,
      isFridayOpen: _profile!.isFridayOpen,
      isSaturdayOpen: _profile!.isSaturdayOpen,
      isSundayOpen: _profile!.isSundayOpen,
      locationDescription: _profile!.locationDescription,
      phoneNumber: _profile!.phoneNumber,
      price: _item!.price!.toInt(),
      itemTitle: _item!.title,
      dateJoined: _profile!.creationTime,
      merchantLocation: LatLng(
        _profile!.gpsLocation!.latitude,
        _profile!.gpsLocation!.longitude,
      ),
      merchantPhotoUrl: _profile!.businessProfilePhoto,
      mondayOpeningTime: _profile!.mondayOpeningHours,
      mondayClosingTime: _profile!.mondayClosingHours,
      tuesdayOpeningTime: _profile!.tuesdayOpeningHours,
      tuesdayClosingTime: _profile!.tuesdayClosingHours,
      wednesdayOpeningTime: _profile!.wednesdayOpeningHours,
      wednesdayClosingTime: _profile!.wednesdayClosingHours,
      thursdayOpeningTime: _profile!.thursdayOpeningHours,
      thursdayClosingTime: _profile!.thursdayClosingHours,
      fridayOpeningTime: _profile!.fridayOpeningHours,
      fridayClosingTime: _profile!.fridayClosingHours,
      saturdayOpeningTime: _profile!.saturdayOpeningHours,
      saturdayClosingTime: _profile!.saturdayClosingHours,
      sundayOpeningTime: _profile!.sundayOpeningHours,
      sundayClosingTime: _profile!.sundayClosingHours,
      currentLocation: _currentLocation,
      distance: (_currentLocation != null)
          ? coordinateDistance(
              _profile!.gpsLocation!.latitude,
              _profile!.gpsLocation!.longitude,
              _currentLocation.latitude,
              _currentLocation.longitude,
            )
          : null,
    );
  }
}
