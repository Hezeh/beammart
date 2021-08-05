import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class SubscriptionsDialog extends StatefulWidget {
  @override
  _SubscriptionsDialogState createState() => _SubscriptionsDialogState();
}

class _SubscriptionsDialogState extends State<SubscriptionsDialog> {
  @override
  Widget build(BuildContext context) {
    final _subsProvider = Provider.of<SubscriptionsProvider>(context);
    List<ProductDetails> _products = _subsProvider.products;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent,
              Colors.amber,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'Unlock Premium Features',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Divider(
              endIndent: 10,
              indent: 10,
              thickness: 5,
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Customizable Analytics'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Unlimited Product Listings'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Higher product rankings'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title:
                        Text('250 Tokens per month for sending SMS Marketing messages'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Delivery By Beammart'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Share your profile & product links'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title:
                        Text('Promote your products on Beammart (coming soon)'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title: Text('Inventory Management Platform (coming soon)'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title:
                        Text('10 Hot Daily Deals per month (coming soon)'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.teal,
                    ),
                    title:
                        Text('Give customers discounts/coupons (coming soon)'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: Center(
                child: Text(
                  "For Just ${_subsProvider.products.firstWhere(
                        (element) => element.id == kGoldSubscriptionId,
                      ).price.toString()} Per Month",
                      style: GoogleFonts.merriweather(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Container(
              // padding: EdgeInsets.only(
              //   top: 5,
              //   left: 10,
              //   right: 10,
              //   bottom: 10,
              // ),
              margin: EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 300, height: 50),
                child: ElevatedButton(
                  child: Text(
                    "Continue ",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    // Subscribe
                    _subsProvider.connection.buyNonConsumable(
                      purchaseParam: PurchaseParam(
                        productDetails: _products.firstWhere(
                          (element) => element.id == kGoldSubscriptionId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    elevation: 16,
                    shadowColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
