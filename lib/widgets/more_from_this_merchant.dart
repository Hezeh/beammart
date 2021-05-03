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

class MoreFromThisMerchant extends StatelessWidget {
  final String merchantId;

  const MoreFromThisMerchant({Key? key, required this.merchantId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _locationProvider = Provider.of<LocationProvider>(context);
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('items')
          .where('userId', isEqualTo: merchantId)
          // .where('itemId', isNotEqualTo: widget.itemId)
          .limit(6)
          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        if (!snap.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
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
                    backgroundColor: Colors.black38,
                    title: Container(),
                    trailing: (_authProvider.user != null)
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('consumers')
                                .doc(_authProvider.user!.uid)
                                .collection('favorites')
                                .doc(snap.data!.docs[index].id)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                                    icon: Icon(Icons.favorite_border_outlined),
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
                  child: InkWell(
                    onTap: () {
                      final GeoPoint _location =
                          snap.data!.docs[index].data()!['location'];
                      final double _lat1 =
                          _locationProvider.currentLocation.latitude;
                      final double _lon1 =
                          _locationProvider.currentLocation.longitude;
                      final double _lat2 = _location.latitude;
                      final double _lon2 = _location.longitude;
                      final _distance = coordinateDistance(
                        _lat1,
                        _lon1,
                        _lat2,
                        _lon2,
                      );

                      final List<String>? _imageUrls = snap.data!.docs[index]
                          .data()!['imageUrls']
                          .cast<String>();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ItemDetail(
                            currentLocation: LatLng(
                              _locationProvider.currentLocation.latitude,
                              _locationProvider.currentLocation.longitude,
                            ),
                            description: (snap.data!.docs[index]
                                        .data()!['description'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['description']
                                : null,
                            distance: _distance,
                            itemId: (snap.data!.docs[index].id != null)
                                ? snap.data!.docs[index].id
                                : null,
                            mondayOpeningTime: (snap.data!.docs[index]
                                        .data()!['mondayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['mondayOpeningHours']
                                : null,
                            mondayClosingTime: (snap.data!.docs[index]
                                        .data()!['mondayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['mondayClosingHours']
                                : null,
                            tuesdayOpeningTime: (snap.data!.docs[index]
                                        .data()!['tuesdayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['tuesdayOpeningHours']
                                : null,
                            tuesdayClosingTime: (snap.data!.docs[index]
                                        .data()!['tuesdayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['tuesdayClosingHours']
                                : null,
                            wednesdayOpeningTime: (snap.data!.docs[index]
                                        .data()!['wednesdayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['wednesdayOpeningHours']
                                : null,
                            wednesdayClosingTime: (snap.data!.docs[index]
                                        .data()!['wednesdayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['wednesdayClosingHours']
                                : null,
                            thursdayOpeningTime: (snap.data!.docs[index]
                                        .data()!['thursdayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['thursdayOpeningHours']
                                : null,
                            thursdayClosingTime: (snap.data!.docs[index]
                                        .data()!['thursdayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['thursdayClosingHours']
                                : null,
                            fridayOpeningTime: (snap.data!.docs[index]
                                        .data()!['fridayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['fridayOpeningHours']
                                : null,
                            fridayClosingTime: (snap.data!.docs[index]
                                        .data()!['fridayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['fridayClosingHours']
                                : null,
                            saturdayOpeningTime: (snap.data!.docs[index]
                                        .data()!['saturdayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['saturdayOpeningHours']
                                : null,
                            saturdayClosingTime: (snap.data!.docs[index]
                                        .data()!['saturdayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['saturdayClosingHours']
                                : null,
                            sundayOpeningTime: (snap.data!.docs[index]
                                        .data()!['sundayOpeningHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['sundayOpeningHours']
                                : null,
                            sundayClosingTime: (snap.data!.docs[index]
                                        .data()!['sundayClosingHours'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['sundayClosingHours']
                                : null,
                            isMondayOpen: (snap.data!.docs[index]
                                        .data()!['isMondayOpen'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['isMondayOpen']
                                : null,
                            isTuesdayOpen: (snap.data!.docs[index]
                                        .data()!['isTuesdayOpen'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['isTuesdayOpen']
                                : null,
                            isWednesdayOpen: (snap.data!.docs[index]
                                        .data()!['isWednesdayOpen'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['isWednesdayOpen']
                                : null,
                            isThursdayOpen: (snap.data!.docs[index]
                                        .data()!['isThursdayOpen'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['isThursdayOpen']
                                : null,
                            isFridayOpen: (snap.data!.docs[index]
                                        .data()!['isFridayOpen'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['isFridayOpen']
                                : null,
                            isSaturdayOpen: (snap.data!.docs[index]
                                        .data()!['isSaturdayOpen'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['isSaturdayOpen']
                                : null,
                            isSundayOpen: (snap.data!.docs[index]
                                        .data()!['isSundayOpen'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['isSundayOpen']
                                : null,
                            itemTitle:
                                (snap.data!.docs[index].data()!['title'] !=
                                        null)
                                    ? snap.data!.docs[index].data()!['title']
                                    : null,
                            imageUrl: _imageUrls,
                            merchantDescription: (snap.data!.docs[index]
                                        .data()!['businessDescription'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['businessDescription']
                                : null,
                            merchantId:
                                (snap.data!.docs[index].data()!['userId'] !=
                                        null)
                                    ? snap.data!.docs[index].data()!['userId']
                                    : null,
                            locationDescription: (snap.data!.docs[index]
                                        .data()!['locationDescription'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['locationDescription']
                                : null,
                            merchantName: (snap.data!.docs[index]
                                        .data()!['businessName'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['businessName']
                                : null,
                            merchantPhotoUrl: (snap.data!.docs[index]
                                        .data()!['businessProfilePhoto'] !=
                                    null)
                                ? snap.data!.docs[index]
                                    .data()!['businessProfilePhoto']
                                : null,
                            phoneNumber: (snap.data!.docs[index]
                                        .data()!['phoneNumber'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['phoneNumber']
                                : null,
                            merchantLocation: LatLng(
                              _location.latitude,
                              _location.longitude,
                            ),
                            price: (snap.data!.docs[index].data()!['price'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['price']
                                : null,
                            dateJoined: (snap.data!.docs[index]
                                        .data()!['dateJoined'] !=
                                    null)
                                ? snap.data!.docs[index].data()!['dateJoined']
                                : null,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          snap.data!.docs[index].data()!['imageUrls'].first,
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
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black38,
                    title: Container(),
                    leading: Text(
                      snap.data!.docs[index].data()!['title'],
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      'Ksh. ${snap.data!.docs[index].data()!['price'].toString()}',
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
      },
    );
  }
}
