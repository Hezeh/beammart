import 'package:beammart/models/item.dart';
import 'package:beammart/models/item_recommendations.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/category_view_all.dart';
import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/screens/web_screens/web_item_detail.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WebRecsCard extends StatelessWidget {
  final int index;
  final AsyncSnapshot<ItemRecommendations> snapshot;
  const WebRecsCard({Key? key, required this.index, required this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryViewAll(
                      categoryName:
                          snapshot.data!.recommendations![index].category,
                    ),
                  ),
                );
              },
              child: Text(
                snapshot.data!.recommendations![index].category!,
                style: GoogleFonts.oxygen(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.pink,
              ),
              onPressed: () {
                clickstreamUtil(
                  index: index,
                  timeStamp: DateTime.now().toIso8601String(),
                  category: snapshot.data!.recommendations![index].category,
                  type: 'CategoryViewAllClick',
                  recsId: snapshot.data!.recsId,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryViewAll(
                      categoryName:
                          snapshot.data!.recommendations![index].category,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 280,
            // padding: EdgeInsets.only(
            //   top: 3,
            // ),
            color: Colors.grey,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.recommendations![index].items!.length,
              itemBuilder: (context, item) {
                final List<Item> _items =
                    snapshot.data!.recommendations![index].items!;

                // final double? _lat1 = (_locationProvider != null)
                //     ? _locationProvider.latitude
                //     : 0;
                // final double? _lon1 = (_locationProvider != null)
                //     ? _locationProvider.longitude
                // : 0;
                final double _lat2 = _items[item].location!.lat!;
                final double _lon2 = _items[item].location!.lon!;
                // final _distance =
                //     coordinateDistance(_lat1, _lon1, _lat2, _lon2);
                return VisibilityDetector(
                  key: Key('RecommendationsItem'),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction > 0.8) {
                      final _timeStamp = DateTime.now().toIso8601String();
                      // Get itemId
                      final _itemId = _items[item].itemId;
                      final _merchantId = _items[item].businessId;
                      final String _uniqueViewId = uuid.v4();
                      onItemView(
                        timeStamp: _timeStamp,
                        itemId: _itemId,
                        viewId: _uniqueViewId,
                        percentage: info.visibleFraction,
                        merchantId: _merchantId,
                        index: index,
                        type: 'Recommendations',
                      );
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      final _itemId = _items[item].itemId;
                      final _merchantId = _items[item].businessId;

                      clickstreamUtil(
                        index: index,
                        timeStamp: DateTime.now().toIso8601String(),
                        category:
                            snapshot.data!.recommendations![index].category,
                        type: 'RecommendationsPageClick',
                        recsId: snapshot.data!.recsId,
                        itemId: _itemId,
                        merchantId: _merchantId,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WebItemDetailScreen(
                            itemId: _items[item].itemId,
                            imageUrl: _items[item].images,
                            itemTitle: _items[item].title,
                            price: _items[item].price,
                            merchantLocation: LatLng(
                              _items[item].location!.lat!,
                              _items[item].location!.lon!,
                            ),
                            description: _items[item].description,
                            dateJoined: _items[item].dateJoined,
                            merchantId: _items[item].businessId,
                            locationDescription:
                                _items[item].locationDescription,
                            merchantDescription:
                                _items[item].businessDescription,
                            merchantName: _items[item].businessName,
                            merchantPhotoUrl: _items[item].merchantPhotoUrl,
                            phoneNumber: _items[item].phoneNumber,
                            // currentLocation: _locationProvider,
                            // distance: _distance,
                            isMondayOpen: _items[item].isMondayOpen,
                            isTuesdayOpen: _items[item].isTuesdayOpen,
                            isWednesdayOpen: _items[item].isWednesdayOpen,
                            isThursdayOpen: _items[item].isThursdayOpen,
                            isFridayOpen: _items[item].isFridayOpen,
                            isSaturdayOpen: _items[item].isSaturdayOpen,
                            isSundayOpen: _items[item].isSundayOpen,
                            mondayOpeningTime: _items[item].mondayOpeningHours,
                            mondayClosingTime: _items[item].mondayClosingHours,
                            tuesdayClosingTime:
                                _items[item].tuesdayClosingHours,
                            tuesdayOpeningTime:
                                _items[item].tuesdayOpeningHours,
                            wednesdayClosingTime:
                                _items[item].wednesdayClosingHours,
                            wednesdayOpeningTime:
                                _items[item].wednesdayOpeningHours,
                            thursdayClosingTime:
                                _items[item].thursdayClosingHours,
                            thursdayOpeningTime:
                                _items[item].thursdayOpeningHours,
                            fridayClosingTime: _items[item].fridayClosingHours,
                            fridayOpeningTime: _items[item].fridayOpeningHours,
                            saturdayClosingTime:
                                _items[item].saturdayClosingHours,
                            saturdayOpeningTime:
                                _items[item].saturdayOpeningHours,
                            sundayClosingTime: _items[item].sundayClosingHours,
                            sundayOpeningTime: _items[item].sundayOpeningHours,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: GridTile(
                                  child: Image.network(
                                    _items[item].images!.first,
                                  ),
                                  header: GridTileBar(
                                    backgroundColor: Colors.black54,
                                    title: Container(),
                                    // leading: (_locationProvider != null)
                                    //     ? Text(
                                    //         '${_distance.toStringAsFixed(2)} Km Away',
                                    //         style: GoogleFonts.gelasio(
                                    //           color: Colors.white,
                                    //           // fontSize: 18,
                                    //           fontWeight: FontWeight.bold,
                                    //         ),
                                    //       )
                                    //     : Text(""),

                                    trailing: (_authProvider.user != null)
                                        ? StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('consumers')
                                                .doc(_authProvider.user!.uid)
                                                .collection('favorites')
                                                .doc(_items[item].itemId)
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snap) {
                                              if (snap.hasData) {
                                                if (snap.data != null &&
                                                    snap.data!.exists) {
                                                  return IconButton(
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: Colors.pink,
                                                    ),
                                                    onPressed: () {
                                                      // Remove from firestore
                                                      deleteFavorite(
                                                        _authProvider.user!.uid,
                                                        _items[item].itemId!,
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
                                                        _items[item].itemId!,
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
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Text(
                                  "Ksh. ${_items[item].price}",
                                  style: GoogleFonts.vidaloka(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 10,
                                ),
                                width: 200,
                                child: Center(
                                  child: Text(
                                    _items[item].title!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.gelasio(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
