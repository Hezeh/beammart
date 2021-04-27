import 'dart:io';

import 'package:beammart/models/category_items.dart';
import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/services/merchant_items_service.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:beammart/utils/coordinate_distance_util.dart';
import 'package:beammart/utils/item_viewstream_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final _currentLocation = Provider.of<LocationProvider>(context);
    final deviceProvider = Provider.of<DeviceInfoProvider>(context).deviceInfo;
    String? deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceProvider!['androidId'];
    }
    if (Platform.isIOS) {
      deviceId = deviceProvider!['identifierForVendor'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Profile'),
      ),
      body: ListView(
        children: [
          (widget.merchantName != null)
              ? Center(
                  child: Container(
                    child: Text(
                      widget.merchantName!,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(),
          CachedNetworkImage(
            imageUrl: widget.merchantPhotoUrl!,
            imageBuilder: (context, imageProvider) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
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
            ),
            placeholder: (context, url) {
              return SizedBox(
                child: Shimmer.fromColors(
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.white,
                    ),
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                ),
              );
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          (widget.dateJoined != null)
              ? Container(
                  child: Text(widget.dateJoined!),
                )
              : Container(),
          (widget.merchantDescription != null)
              ? Container(
                  margin: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Text(
                    widget.merchantDescription!,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
          (widget.phoneNumber != null)
              ? Container(
                  margin: EdgeInsets.all(10),
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      clickstreamUtil(
                        deviceId: deviceId,
                        timeStamp: DateTime.now().toIso8601String(),
                        lat: _currentLocation.currentLocation.latitude,
                        lon: _currentLocation.currentLocation.longitude,
                        type: 'ProfileCallClick',
                        merchantId: widget.merchantId,
                      );
                      _makePhoneCall('tel:${widget.phoneNumber}');
                    },
                    icon: Icon(
                      Icons.call_outlined,
                    ),
                    label: Text(
                      'CALL',
                      style: GoogleFonts.oswald(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(),
          Container(
            child: Center(
              child: Container(
                child: Text(
                  'Operating Hours',
                  style: GoogleFonts.gelasio(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Day',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Opening',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Closing',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: <DataRow>[
              widget.isMondayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Monday')),
                        DataCell(
                          (widget.mondayOpeningTime != null)
                              ? Text(widget.mondayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.mondayClosingTime != null)
                              ? Text(widget.mondayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Monday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isTuesdayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Tuesday')),
                        DataCell(
                          (widget.tuesdayOpeningTime != null)
                              ? Text(widget.tuesdayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.tuesdayClosingTime != null)
                              ? Text(widget.tuesdayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Tuesday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isWednesdayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Wednesday')),
                        DataCell(
                          (widget.wednesdayOpeningTime != null)
                              ? Text(widget.wednesdayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.wednesdayClosingTime != null)
                              ? Text(widget.wednesdayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Wednesday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isThursdayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Thursday')),
                        DataCell(
                          (widget.thursdayOpeningTime != null)
                              ? Text(widget.thursdayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.thursdayClosingTime != null)
                              ? Text(widget.thursdayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Thursday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isFridayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Friday')),
                        DataCell(
                          (widget.fridayOpeningTime != null)
                              ? Text(widget.fridayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.fridayClosingTime != null)
                              ? Text(widget.fridayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Friday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isSaturdayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Saturday')),
                        DataCell(
                          (widget.saturdayOpeningTime != null)
                              ? Text(widget.saturdayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.saturdayClosingTime != null)
                              ? Text(widget.saturdayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Saturday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
              widget.isSundayOpen!
                  ? DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Sunday')),
                        DataCell(
                          (widget.sundayOpeningTime != null)
                              ? Text(widget.sundayOpeningTime!)
                              : Container(),
                        ),
                        DataCell(
                          (widget.sundayClosingTime != null)
                              ? Text(widget.sundayClosingTime!)
                              : Container(),
                        ),
                      ],
                    )
                  : DataRow(cells: [
                      DataCell(
                        Text('Sunday'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                      DataCell(
                        Text('Closed'),
                      ),
                    ]),
            ],
          ),
          Divider(),
          SizedBox(
            height: 15,
          ),
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
                    final double _lat1 =
                        _currentLocation.currentLocation.latitude;
                    final double _lon1 =
                        _currentLocation.currentLocation.longitude;
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
                          onItemView(
                            timeStamp: _timeStamp,
                            deviceId: deviceId,
                            itemId: _itemId,
                            viewId: _uniqueViewId,
                            percentage: info.visibleFraction,
                            merchantId: _merchantId,
                            lat: _currentLocation.currentLocation.latitude,
                            lon: _currentLocation.currentLocation.longitude,
                            index: index,
                            type: 'MerchantProfileItems',
                          );
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          clickstreamUtil(
                            deviceId: deviceId,
                            index: index,
                            timeStamp: DateTime.now().toIso8601String(),
                            category: snapshot.data!.items![index].category,
                            lat: _currentLocation.currentLocation.latitude,
                            lon: _currentLocation.currentLocation.longitude,
                            type: 'ProfileItemClick',
                            itemId: snapshot.data!.items![index].itemId,
                            merchantId: snapshot.data!.items![index].businessId,
                          );
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
                                currentLocation: LatLng(
                                  _currentLocation.currentLocation.latitude,
                                  _currentLocation.currentLocation.longitude,
                                ),
                                distance: _distance,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GridTile(
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
                                  topRight: Radius.circular(10)),
                              child: GridTileBar(
                                backgroundColor: Colors.black26,
                                title:
                                    Text(snapshot.data!.items![index].title!),
                                trailing: Text(
                                  snapshot.data!.items![index].price.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
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
