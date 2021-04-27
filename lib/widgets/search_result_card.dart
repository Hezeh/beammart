import 'package:beammart/screens/item_detail.dart';
import 'package:beammart/utils/clickstream_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultCard extends StatelessWidget {
  final String? itemId;
  final String? title;
  final String? description;
  final int? price;
  final double? distance;
  final List<String>? imageUrl;
  final String? phoneNumber;
  final String? merchantPhotoUrl;
  final String? merchantName;
  final String? merchantId;
  final LatLng? merchantLocation;
  final LatLng? currentLocation;
  final String? dateJoined;
  final String? merchantDescription;
  final String? locationDescription;
  final bool? inStock;
  final bool? isOpen;
  final String? openingOrClosingTime;
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
  final String? deviceId;
  final int? index;
  final String? searchId;
  final String? searchQuery;
  final String? category;
  final String? subCategory;

  const SearchResultCard({
    Key? key,
    this.title,
    this.description,
    this.price,
    this.distance,
    this.imageUrl,
    this.phoneNumber,
    this.merchantName,
    this.merchantPhotoUrl,
    this.merchantId,
    this.merchantLocation,
    this.currentLocation,
    this.dateJoined,
    this.merchantDescription,
    this.locationDescription,
    this.inStock,
    this.isOpen,
    this.openingOrClosingTime,
    this.itemId,
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
    this.deviceId,
    this.index,
    this.searchId,
    this.searchQuery,
    this.category,
    this.subCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        clickstreamUtil(
          deviceId: deviceId,
          index: index,
          timeStamp: DateTime.now().toIso8601String(),
          category: category,
          lat: currentLocation!.latitude,
          lon: currentLocation!.longitude,
          type: 'SearchPageItemClick',
          searchId: searchId,
          searchQuery: searchQuery,
          itemId: itemId,
          merchantId: merchantId,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ItemDetail(
              itemTitle: title,
              description: description,
              price: price,
              imageUrl: imageUrl,
              merchantLocation: merchantLocation,
              currentLocation: currentLocation,
              distance: distance,
              dateJoined: dateJoined,
              merchantId: merchantId,
              merchantName: merchantName,
              merchantDescription: merchantDescription,
              merchantPhotoUrl: merchantPhotoUrl,
              phoneNumber: phoneNumber,
              locationDescription: locationDescription,
              isMondayOpen: isMondayOpen,
              isTuesdayOpen: isTuesdayOpen,
              isWednesdayOpen: isWednesdayOpen,
              isThursdayOpen: isThursdayOpen,
              isFridayOpen: isFridayOpen,
              isSaturdayOpen: isSaturdayOpen,
              isSundayOpen: isSundayOpen,
              mondayOpeningTime: mondayOpeningTime,
              mondayClosingTime: mondayClosingTime,
              tuesdayOpeningTime: tuesdayOpeningTime,
              tuesdayClosingTime: tuesdayClosingTime,
              wednesdayOpeningTime: wednesdayOpeningTime,
              wednesdayClosingTime: wednesdayClosingTime,
              thursdayOpeningTime: thursdayClosingTime,
              thursdayClosingTime: thursdayClosingTime,
              fridayOpeningTime: fridayOpeningTime,
              fridayClosingTime: fridayClosingTime,
              saturdayOpeningTime: saturdayOpeningTime,
              saturdayClosingTime: saturdayClosingTime,
              sundayOpeningTime: sundayOpeningTime,
              sundayClosingTime: sundayClosingTime,
              itemId: itemId,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 30,
        borderOnForeground: true,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: imageUrl!.first,
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
                        height: 300,
                        color: Colors.white,
                      ),
                    ),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            ListTile(
              title: Text(
                title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                description!,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Chip(
                    // backgroundColor: Colors.green,
                    label: inStock!
                        ? Text(
                            'In Stock',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              // color: Colors.green,
                            ),
                          )
                        : Text(
                            'Out of Stock',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                    avatar: inStock!
                        ? Icon(Icons.done)
                        : Icon(Icons.cancel_outlined),
                  ),
                ),
                Flexible(
                  child: Chip(
                    avatar: Icon(Icons.money_rounded),
                    label: Text(
                      '$price',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Chip(
                    avatar: Icon(Icons.room_outlined),
                    label: Text(
                      '${distance!.toStringAsFixed(2)} Km',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              leading: isOpen!
                  ? Text(
                      'Open',
                      style: GoogleFonts.roboto(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  : Text(
                      'Closed',
                      style: GoogleFonts.roboto(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
              trailing: Text(
                openingOrClosingTime!,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
