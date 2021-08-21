import 'package:beammart/models/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order? order;

  const OrderDetailScreen({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
      ),
      body: ListView(
        children: [
          Card(
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
                (order!.item!.images != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: order!.item!.images!.first.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 150,
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
                                  height: 150,
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
                          "${order!.item!.businessName}",
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
                          "${order!.quantity} X ${order!.item!.title}",
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
                          "Ksh. ${order!.totalOrderAmount}",
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
          ),
          (order!.accepted == null)
              ? ListTile(
                  title: Text("Order Status"),
                  subtitle: Text("Awaiting Confirmation By Merchant"),
                )
              : ListTile(
                  title: Text("Order Status"),
                  subtitle: (order!.accepted!)
                      ? Text("Merchant Confirmed Your Order")
                      : Text("Order Declined By Merchant"),
                ),
          ListTile(
            title: Text("Delivery Status"),
            subtitle: (order!.delivered!)
                ? Text("Delivered")
                : Text("Delivery In Progress"),
          ),
          ListTile(
            title: Text("Merchant Address"),
            subtitle: Text(
                "${order!.merchantAddress!.addressName}, ${order!.merchantAddress!.addressDescription}"),
          ),
          ListTile(
            title: Text("Delivery Address"),
            subtitle: Text("${order!.consumerAddress!.addressName}"),
          ),
          ListTile(
            title: Text("Order Id"),
            subtitle: Text("${order!.orderId}"),
          ),
          ListTile(
            title: Text("Order Timestamp"),
            subtitle: Text("${order!.orderTimestamp}"),
          ),
          // Total
          ListTile(
            title: Text("Total Order Amount"),
            trailing: Text("${order!.totalOrderAmount}"),
          )
        ],
      ),
    );
  }
}
