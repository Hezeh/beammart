import 'package:beammart/models/consumer_address.dart';
import 'package:beammart/models/item.dart';
import 'package:beammart/screens/consumer_orders.dart';
import 'package:beammart/utils/buy_with_card.dart';
import 'package:beammart/utils/order_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ConfirmAndPaymentScreen extends StatelessWidget {
  final String? itemTitle;
  final int? itemQuantity;
  final String? itemDescription;
  final int? price;
  final ConsumerAddress? shippingAddress;
  final String? itemImage;
  final Item? item;

  const ConfirmAndPaymentScreen({
    Key? key,
    this.itemTitle,
    this.itemQuantity,
    this.price,
    this.shippingAddress,
    this.itemImage,
    this.itemDescription,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? _subTotal = (itemQuantity! * price!).toDouble();
    double? _shippingFee = 0.0;
    double? _total = _subTotal + _shippingFee;
    return Scaffold(
      persistentFooterButtons: [
        ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: ElevatedButton(
              // child: Text("Pay $_total & Ship"),
              child: Text("Order"),
              onPressed: () async {
                // Payment Logic
                // await buyWithCard(context, _total).then((value) {
                //   // Navigator.of(context, rootNavigator: true).pop();
                //   Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //       builder: (_) => ConsumerOrders(),
                //     ),
                //     ModalRoute.withName('/'),
                //   );
                // });
                createOrder(
                  context,
                  item: item,
                  consumerAddress: shippingAddress,
                  itemQuantity: itemQuantity,
                  totalOrderAmount: _total,
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => ConsumerOrders(),
                  ),
                  ModalRoute.withName('/'),
                );
              },
            )),
      ],
      appBar: AppBar(
        title: Text("Confirm Order"),
      ),
      body: ListView(
        children: [
          Container(
            // height: 200,
            margin: EdgeInsets.all(10),
            child: (itemImage != null)
                ? CachedNetworkImage(
                    imageUrl: itemImage!,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 200,
                        // width: 100,
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
              (itemTitle != null)
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        itemTitle!,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              (itemDescription != null)
                  ? Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        itemDescription!,
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.grey[700]),
                      ),
                    )
                  : Container(),
            ],
          ),

          // Quantity
          ListTile(
            title: Text("Quantity"),
            trailing: Text("$itemQuantity"),
          ),
          // Address
          ListTile(
            title: Text("Shipping Address"),
            subtitle: Text("${shippingAddress!.addressName}"),
          ),

          // Item Subtotal
          ListTile(
            title: Text("Subtotal"),
            trailing: Text("$_subTotal"),
          ),
          // Shipping fee
          ListTile(
            title: Text("Shipping"),
            trailing: Text("$_shippingFee"),
          ),
          // Discounts
          // Total
          ListTile(
            title: Text("Total"),
            trailing: Text("$_total"),
          ),
        ],
      ),
    );
  }
}
