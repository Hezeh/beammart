import 'package:beammart/screens/consumer_address_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BuyAndShipScreen extends StatefulWidget {
  final String? itemImage;
  final String? itemTitle;
  final String? itemDescription;
  final String? merchantId;
  final int? itemPrice;
  final String? itemId;

  const BuyAndShipScreen({
    Key? key,
    this.itemImage,
    this.itemTitle,
    this.itemDescription,
    this.merchantId,
    this.itemPrice,
    this.itemId,
  }) : super(key: key);

  @override
  State<BuyAndShipScreen> createState() => _BuyAndShipScreenState();
}

class _BuyAndShipScreenState extends State<BuyAndShipScreen> {
  int itemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: ElevatedButton(
            child: Text("Checkout"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConsumerAddressScreen(
                    checkout: true,
                    itemDescription: widget.itemDescription,
                    itemId: widget.itemId,
                    merchantId: widget.merchantId,
                    itemTitle: widget.itemTitle,
                    quantity: itemQuantity,
                    price: widget.itemPrice,
                    itemImage: widget.itemImage,
                  ),
                ),
              );
            },
          ),
        )
      ],
      appBar: AppBar(
        title: Text("Buy & Ship"),
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.itemImage!,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 350,
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
                              height: 350,
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
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          "Ksh. ${widget.itemPrice}",
                          style: GoogleFonts.vidaloka(
                            fontWeight: FontWeight.bold,
                          ),
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
                          widget.itemTitle!,
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
            // Quantity
            Center(
              child: Text(
                "Quantity",
                style: GoogleFonts.gelasio(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              // color: Colors.yellow,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Remove Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (itemQuantity > 1) {
                            itemQuantity -= 1;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.remove_outlined,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // Current Number
                    Text(
                      "$itemQuantity",
                      style: GoogleFonts.gelasio(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // Add Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (itemQuantity >= 1) {
                            itemQuantity += 1;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
