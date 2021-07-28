import 'package:beammart/models/profile.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/arguments/shop_named_screen_arguments.dart';
import 'package:beammart/screens/merchant_profile.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopNamedScreen extends StatefulWidget {
  const ShopNamedScreen({Key? key}) : super(key: key);

  @override
  State<ShopNamedScreen> createState() => _ShopNamedScreenState();
}

class _ShopNamedScreenState extends State<ShopNamedScreen> {
  bool shopLoading = true;
  Profile? _profile;

  @override
  Widget build(BuildContext context) {
    final _locationProvider = Provider.of<LocationProvider>(context);
    final _currentLocation = _locationProvider.currentLoc;
    final args =
        ModalRoute.of(context)!.settings.arguments as ShopNamedScreenArguments;
    final _shopId = args.shopId;

    _getShopDetails() async {
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

    _getShopDetails();

    if (shopLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Merchant Profile"),
        ),
      );
    }
    return MerchantProfile(
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
      // locationDescription: _profile!.locationDescription,
      phoneNumber: _profile!.phoneNumber,
      dateJoined: _profile!.creationTime,
      // merchantLocation: LatLng(
      //   _profile!.gpsLocation!.latitude,
      //   _profile!.gpsLocation!.longitude,
      // ),
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
      // currentLocation: _currentLocation,
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
