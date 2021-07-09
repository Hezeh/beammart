import 'dart:io';

import 'package:beammart/models/category_items.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/services/favorites_service.dart';
import 'package:beammart/services/merchant_items_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:beammart/widgets/operating_hours_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'item_detail.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class MerchantProfile extends StatefulWidget {
  final String? merchantName;
  final String? merchantPhotoUrl;
  final String? dateJoined;
  final String? merchantId;
  final String? merchantDescription;
  final double? distance;
  final String? phoneNumber;
  final bool? isMondayOpen;
  final bool? isTuesdayOpen;
  final bool? isWednesdayOpen;
  final bool? isThursdayOpen;
  final bool? isFridayOpen;
  final bool? isSaturdayOpen;
  final bool? isSundayOpen;
  final String? mondayOpeningTime;
  final String? mondayClosingTime;
  final String? tuesdayOpeningTime;
  final String? tuesdayClosingTime;
  final String? wednesdayOpeningTime;
  final String? wednesdayClosingTime;
  final String? thursdayOpeningTime;
  final String? thursdayClosingTime;
  final String? fridayOpeningTime;
  final String? fridayClosingTime;
  final String? saturdayOpeningTime;
  final String? saturdayClosingTime;
  final String? sundayOpeningTime;
  final String? sundayClosingTime;

  const MerchantProfile({
    Key? key,
    this.merchantName,
    this.merchantPhotoUrl,
    this.dateJoined,
    this.merchantId,
    this.merchantDescription,
    this.distance,
    this.phoneNumber,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.mondayOpeningTime,
    this.mondayClosingTime,
    this.tuesdayOpeningTime,
    this.tuesdayClosingTime,
    this.wednesdayOpeningTime,
    this.wednesdayClosingTime,
    this.thursdayOpeningTime,
    this.thursdayClosingTime,
    this.fridayOpeningTime,
    this.fridayClosingTime,
    this.saturdayOpeningTime,
    this.saturdayClosingTime,
    this.sundayOpeningTime,
    this.sundayClosingTime,
  }) : super(key: key);

  @override
  _MerchantProfileState createState() => _MerchantProfileState();
}

class _MerchantProfileState extends State<MerchantProfile> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _currentLocation = Provider.of<LatLng?>(context);
    final _currentLocation = Provider.of<LocationProvider>(context).currentLoc;
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    String? chatId;
    String? deviceId; 
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }
    getChatId() async {
      if (_authProvider.user != null) {
        final _chatSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .where(
              'consumerId',
              isEqualTo: _authProvider.user!.uid,
            )
            .where(
              'businessId',
              isEqualTo: widget.merchantId,
            )
            .get();
        chatId = _chatSnapshot.docs.first.id;
      } else {
        chatId = uuid.v4();
      }
    }

    getChatId();
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Profile'),
      ),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: (widget.merchantPhotoUrl != null)
                    ? CachedNetworkImage(
                        imageUrl: widget.merchantPhotoUrl!,
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 100,
                            width: 100,
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
                        ),
                        placeholder: (context, url) {
                          return SizedBox(
                            child: Shimmer.fromColors(
                              child: Card(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                ),
                              ),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : SizedBox.shrink(),
              ),
              Column(
                children: [
                  (widget.merchantName != null)
                      ? Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            widget.merchantName!,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  (widget.merchantDescription != null)
                      ? Container(
                          child: Text(
                            widget.merchantDescription!,
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
          (widget.dateJoined != null)
              ? Container(
                  child: Text(widget.dateJoined!),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              (widget.phoneNumber != null)
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 150,
                      ),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.call_outlined),
                        onPressed: () {
                          clickstreamUtil(
                            deviceId: deviceId,
                            timeStamp: DateTime.now().toIso8601String(),
                            lat: _currentLocation!.latitude,
                            lon: _currentLocation.longitude,
                            type: 'ProfileCallClick',
                            merchantId: widget.merchantId,
                          );
                          _makePhoneCall('tel:${widget.phoneNumber}');
                        },
                        label: Text(
                          'CALL',
                          style: GoogleFonts.oswald(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 150,
                ),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.chat_bubble_outline_outlined,
                  ),
                  onPressed: () {
                    if (_authProvider.user != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chatId,
                            businessName: widget.merchantName,
                            businessId: widget.merchantId,
                            businessPhotoUrl: widget.merchantPhotoUrl,
                            consumerDisplayName:
                                _authProvider.user!.displayName,
                            consumerId: _authProvider.user!.uid,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(
                            showCloseIcon: true,
                          ),
                        ),
                      );
                    }
                  },
                  label: Text("Chat"),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: OperatingHoursWidget(
              isMondayOpen: widget.isMondayOpen,
              isTuesdayOpen: widget.isTuesdayOpen,
              isWednesdayOpen: widget.isWednesdayOpen,
              isThursdayOpen: widget.isThursdayOpen,
              isFridayOpen: widget.isFridayOpen,
              isSaturdayOpen: widget.isSaturdayOpen,
              isSundayOpen: widget.isSundayOpen,
              mondayOpeningTime: widget.mondayOpeningTime,
              mondayClosingTime: widget.mondayClosingTime,
              tuesdayOpeningTime: widget.tuesdayOpeningTime,
              tuesdayClosingTime: widget.tuesdayClosingTime,
              wednesdayOpeningTime: widget.wednesdayOpeningTime,
              wednesdayClosingTime: widget.wednesdayClosingTime,
              thursdayOpeningTime: widget.thursdayOpeningTime,
              thursdayClosingTime: widget.thursdayClosingTime,
              fridayOpeningTime: widget.fridayOpeningTime,
              fridayClosingTime: widget.fridayClosingTime,
              saturdayOpeningTime: widget.saturdayOpeningTime,
              saturdayClosingTime: widget.saturdayClosingTime,
              sundayOpeningTime: widget.sundayOpeningTime,
              sundayClosingTime: widget.sundayClosingTime,
            ),
          ),
          Divider(),
          Container(
            child: Center(
              child: Text(
                'All Products',
                style: GoogleFonts.gelasio(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
            future: getMerchantItems(widget.merchantId),
            builder: (context, AsyncSnapshot<CategoryItems> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    childAspectRatio: .7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.items!.length,
                  itemBuilder: (context, index) {
                    double? _lat1 = 0;
                    double? _lon1 = 0;
                    if (_currentLocation != null) {
                      _lat1 = _currentLocation.latitude;
                      _lon1 = _currentLocation.longitude;
                    }

                    final double _lat2 =
                        snapshot.data!.items![index].location!.lat!;
                    final double _lon2 =
                        snapshot.data!.items![index].location!.lon!;
                    final _distance =
                        coordinateDistance(_lat1, _lon1, _lat2, _lon2);
                    return VisibilityDetector(
                      key: Key('MerchantProfileKey'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.8) {
                          final _timeStamp = DateTime.now().toIso8601String();
                          // Get itemId
                          final _itemId = snapshot.data!.items![index].itemId;
                          final _merchantId =
                              snapshot.data!.items![index].businessId;
                          final String _uniqueViewId = uuid.v4();
                          if (_currentLocation != null) {
                            onItemView(
                              timeStamp: _timeStamp,
                              deviceId: deviceId,
                              itemId: _itemId,
                              viewId: _uniqueViewId,
                              percentage: info.visibleFraction,
                              merchantId: _merchantId,
                              lat: _currentLocation.latitude,
                              lon: _currentLocation.longitude,
                              index: index,
                              type: 'MerchantProfileItems',
                            );
                          } else {
                            onItemView(
                              timeStamp: _timeStamp,
                              deviceId: deviceId,
                              itemId: _itemId,
                              viewId: _uniqueViewId,
                              percentage: info.visibleFraction,
                              merchantId: _merchantId,
                              index: index,
                              type: 'MerchantProfileItems',
                            );
                          }
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          if (_currentLocation != null) {
                            clickstreamUtil(
                              deviceId: deviceId,
                              index: index,
                              timeStamp: DateTime.now().toIso8601String(),
                              category: snapshot.data!.items![index].category,
                              lat: _currentLocation.latitude,
                              lon: _currentLocation.longitude,
                              type: 'ProfileItemClick',
                              itemId: snapshot.data!.items![index].itemId,
                              merchantId:
                                  snapshot.data!.items![index].businessId,
                            );
                          } else {
                            clickstreamUtil(
                              deviceId: deviceId,
                              index: index,
                              timeStamp: DateTime.now().toIso8601String(),
                              category: snapshot.data!.items![index].category,
                              type: 'ProfileItemClick',
                              itemId: snapshot.data!.items![index].itemId,
                              merchantId:
                                  snapshot.data!.items![index].businessId,
                            );
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ItemDetail(
                                itemTitle: snapshot.data!.items![index].title,
                                itemId: snapshot.data!.items![index].itemId,
                                description:
                                    snapshot.data!.items![index].description,
                                price: snapshot.data!.items![index].price,
                                isMondayOpen:
                                    snapshot.data!.items![index].isMondayOpen,
                                isTuesdayOpen:
                                    snapshot.data!.items![index].isTuesdayOpen,
                                isWednesdayOpen: snapshot
                                    .data!.items![index].isWednesdayOpen,
                                isThursdayOpen:
                                    snapshot.data!.items![index].isThursdayOpen,
                                isFridayOpen:
                                    snapshot.data!.items![index].isFridayOpen,
                                isSaturdayOpen:
                                    snapshot.data!.items![index].isSaturdayOpen,
                                isSundayOpen:
                                    snapshot.data!.items![index].isSundayOpen,
                                mondayOpeningTime: snapshot
                                    .data!.items![index].mondayOpeningHours,
                                mondayClosingTime: snapshot
                                    .data!.items![index].mondayClosingHours,
                                tuesdayOpeningTime: snapshot
                                    .data!.items![index].tuesdayOpeningHours,
                                tuesdayClosingTime: snapshot
                                    .data!.items![index].tuesdayClosingHours,
                                wednesdayOpeningTime: snapshot
                                    .data!.items![index].wednesdayOpeningHours,
                                wednesdayClosingTime: snapshot
                                    .data!.items![index].wednesdayClosingHours,
                                thursdayClosingTime: snapshot
                                    .data!.items![index].thursdayClosingHours,
                                thursdayOpeningTime: snapshot
                                    .data!.items![index].thursdayOpeningHours,
                                fridayClosingTime: snapshot
                                    .data!.items![index].fridayClosingHours,
                                fridayOpeningTime: snapshot
                                    .data!.items![index].fridayOpeningHours,
                                saturdayClosingTime: snapshot
                                    .data!.items![index].saturdayClosingHours,
                                saturdayOpeningTime: snapshot
                                    .data!.items![index].saturdayOpeningHours,
                                sundayClosingTime: snapshot
                                    .data!.items![index].sundayClosingHours,
                                sundayOpeningTime: snapshot
                                    .data!.items![index].sundayOpeningHours,
                                dateJoined:
                                    snapshot.data!.items![index].dateJoined,
                                imageUrl: snapshot.data!.items![index].images,
                                merchantDescription: snapshot
                                    .data!.items![index].businessDescription,
                                locationDescription: snapshot
                                    .data!.items![index].locationDescription,
                                merchantId:
                                    snapshot.data!.items![index].businessId,
                                phoneNumber:
                                    snapshot.data!.items![index].phoneNumber,
                                merchantName:
                                    snapshot.data!.items![index].businessName,
                                merchantPhotoUrl: snapshot
                                    .data!.items![index].merchantPhotoUrl,
                                merchantLocation: LatLng(
                                    snapshot.data!.items![index].location!.lat!,
                                    snapshot
                                        .data!.items![index].location!.lon!),
                                currentLocation: (_currentLocation != null)
                                    ? LatLng(
                                        _currentLocation.latitude,
                                        _currentLocation.longitude,
                                      )
                                    : null,
                                distance: _distance,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
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
                                            .doc(snapshot
                                                .data!.items![index].itemId)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
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
                                                icon: Icon(Icons
                                                    .favorite_border_outlined),
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
                              child: CachedNetworkImage(
                                imageUrl:
                                    snapshot.data!.items![index].images!.first,
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
                              footer: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: GridTileBar(
                                  backgroundColor: Colors.black26,
                                  title:
                                      Text(snapshot.data!.items![index].title!),
                                  trailing: Text(
                                    'Ksh.${snapshot.data!.items![index].price.toString()}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
