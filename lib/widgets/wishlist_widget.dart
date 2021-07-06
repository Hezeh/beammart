import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WishlistWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    // final _locationProvider = Provider.of<LatLng?>(context);
    final LatLng? _locationProvider = Provider.of<LocationProvider>(context).currentLoc;
    final _currentUser = _authProvider.user;

    if (_currentUser != null) {
      final _docs = FirebaseFirestore.instance
          .collection('consumers')
          .doc(_authProvider.user!.uid)
          .collection('favorites')
          .snapshots();
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _docs,
                builder: (context, snap) {
                  // print("Length: ${snap.data!.docs.length}");
                  if (snap.hasData) {
                    if (snap.data != null) {
                      if (snap.data!.docs.length == 0) {
                        return Center(
                          child: Text("No Items in Wishlist"),
                        );
                      }
                      return GridView.builder(
                        itemCount: snap.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350,
                          childAspectRatio: .7,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GridTile(
                                header: GridTileBar(
                                  backgroundColor: Colors.transparent,
                                  title: Container(),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.favorite_outlined,
                                      color: Colors.pink,
                                    ),
                                    onPressed: () {
                                      deleteFavorite(
                                        _authProvider.user!.uid,
                                        snap.data!.docs[index].id,
                                      );
                                    },
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    final GeoPoint _location = snap
                                        .data!.docs[index]
                                        .data()['location'];
                                    final double _lat1 =
                                        _locationProvider!.latitude;
                                    final double _lon1 =
                                        _locationProvider.longitude;
                                    final double _lat2 = _location.latitude;
                                    final double _lon2 = _location.longitude;
                                    final _distance = coordinateDistance(
                                      _lat1,
                                      _lon1,
                                      _lat2,
                                      _lon2,
                                    );

                                    final List<String>? _imageUrls = snap
                                        .data!.docs[index]
                                        .data()['imageUrls']
                                        .cast<String>();

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ItemDetail(
                                          currentLocation: LatLng(
                                            _locationProvider.latitude,
                                            _locationProvider.longitude,
                                          ),
                                          description: (snap.data!.docs[index]
                                                      .data()['description'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['description']
                                              : null,
                                          distance: _distance,
                                          itemId: (snap.data!.docs[index].id !=
                                                  null)
                                              ? snap.data!.docs[index].id
                                              : null,
                                          mondayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'mondayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['mondayOpeningHours']
                                              : null,
                                          mondayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'mondayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['mondayClosingHours']
                                              : null,
                                          tuesdayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'tuesdayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'tuesdayOpeningHours']
                                              : null,
                                          tuesdayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'tuesdayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'tuesdayClosingHours']
                                              : null,
                                          wednesdayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'wednesdayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'wednesdayOpeningHours']
                                              : null,
                                          wednesdayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'wednesdayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'wednesdayClosingHours']
                                              : null,
                                          thursdayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'thursdayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'thursdayOpeningHours']
                                              : null,
                                          thursdayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'thursdayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'thursdayClosingHours']
                                              : null,
                                          fridayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'fridayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['fridayOpeningHours']
                                              : null,
                                          fridayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'fridayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['fridayClosingHours']
                                              : null,
                                          saturdayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'saturdayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'saturdayOpeningHours']
                                              : null,
                                          saturdayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'saturdayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'saturdayClosingHours']
                                              : null,
                                          sundayOpeningTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'sundayOpeningHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['sundayOpeningHours']
                                              : null,
                                          sundayClosingTime: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'sundayClosingHours'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['sundayClosingHours']
                                              : null,
                                          isMondayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isMondayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isMondayOpen']
                                                  : null,
                                          isTuesdayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isTuesdayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isTuesdayOpen']
                                                  : null,
                                          isWednesdayOpen: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'isWednesdayOpen'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['isWednesdayOpen']
                                              : null,
                                          isThursdayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isThursdayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isThursdayOpen']
                                                  : null,
                                          isFridayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isFridayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isFridayOpen']
                                                  : null,
                                          isSaturdayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isSaturdayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isSaturdayOpen']
                                                  : null,
                                          isSundayOpen:
                                              (snap.data!.docs[index].data()[
                                                          'isSundayOpen'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['isSundayOpen']
                                                  : null,
                                          itemTitle: (snap.data!.docs[index]
                                                      .data()['title'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['title']
                                              : null,
                                          imageUrl: _imageUrls,
                                          merchantDescription: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'businessDescription'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'businessDescription']
                                              : null,
                                          merchantId: (snap.data!.docs[index]
                                                      .data()['userId'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['userId']
                                              : null,
                                          locationDescription: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'locationDescription'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'locationDescription']
                                              : null,
                                          merchantName:
                                              (snap.data!.docs[index].data()[
                                                          'businessName'] !=
                                                      null)
                                                  ? snap.data!.docs[index]
                                                      .data()['businessName']
                                                  : null,
                                          merchantPhotoUrl: (snap
                                                          .data!.docs[index]
                                                          .data()[
                                                      'businessProfilePhoto'] !=
                                                  null)
                                              ? snap.data!.docs[index].data()[
                                                  'businessProfilePhoto']
                                              : null,
                                          phoneNumber: (snap.data!.docs[index]
                                                      .data()['phoneNumber'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['phoneNumber']
                                              : null,
                                          merchantLocation: LatLng(
                                            _location.latitude,
                                            _location.longitude,
                                          ),
                                          price: (snap.data!.docs[index]
                                                      .data()['price'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['price']
                                              : null,
                                          dateJoined: (snap.data!.docs[index]
                                                      .data()['dateJoined'] !=
                                                  null)
                                              ? snap.data!.docs[index]
                                                  .data()['dateJoined']
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: snap.data!.docs[index]
                                        .data()['imageUrls']
                                        .first,
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
                                ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  title: Container(),
                                  leading: Text(
                                    snap.data!.docs[index].data()['title'],
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Text(
                                    'Ksh. ${snap.data!.docs[index].data()['price'].toString()}',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      Center(
                        child: Text("No items in Wishlist"),
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return LoginScreen(
        showCloseIcon: false,
      );
    }
  }
}
