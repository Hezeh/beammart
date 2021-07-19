import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ConsumerOrderCard extends StatelessWidget {
  final String? itemId;
  final String? merchantName;
  final String? imageUrl;
  final String? itemTitle;
  final double? orderTotalAmount;
  final int? itemQuantity;

  const ConsumerOrderCard({
    Key? key,
    this.itemId,
    this.merchantName,
    this.imageUrl,
    this.itemTitle,
    this.orderTotalAmount,
    this.itemQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (imageUrl != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 250,
                      width: 150,
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "$merchantName",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "$itemQuantity X $itemTitle",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Ksh. $orderTotalAmount",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
