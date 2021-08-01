import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class PaymentsSubscriptionsScreen extends StatelessWidget {
  const PaymentsSubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _subsProvider = Provider.of<SubscriptionsProvider>(context);
    List<ProductDetails> _products = _subsProvider.products;
    _subsProvider.products.forEach((product) {
      print("${product.id}");
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Subscriptions"),
      ),
      body: ListView(
        children: [
          // Bronze Package
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    // Colors.pink,
                    Colors.purple,
                    Colors.yellow,
                  ],
                ),
              ),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text("Bronze Package Features"),
                    ),
                  ),
                  Text("Share Your Item and Shop Links with Others"),
                  Text("50 Branded SMS Messages Per Month"),
                  Text("Delivery By Beammart"),
                  Text("10 Deals Per Month"),
                  Text("20 Product Listings"),
                  Text("Inventory Management"),
                  Text("Daily Inventory Management Reminders"),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: 50,
                      ),
                      child: ElevatedButton(
                        child: Text("${_subsProvider.products.firstWhere(
                              (element) => element.id == kBronzeSubscriptionId,
                            ).price.toString()} Per Month"),
                        onPressed: () {
                          // Subscribe
                          _subsProvider.connection.buyNonConsumable(
                            purchaseParam: PurchaseParam(
                              productDetails: _products.firstWhere(
                                (element) =>
                                    element.id == kBronzeSubscriptionId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Silver Package
          Card(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Center(
                  child: Text("Silver Package Features"),
                ),
                Text("Share Your Item and Shop Links with Others"),
                Text("250 Branded SMS Messages Per Month"),
                Text("Delivery By Beammart"),
                Text("30 Deals Per Month"),
                Text("50 Product Listings"),
                Text("Inventory Management"),
                Text("Daily Inventory Management Reminders"),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 50,
                    ),
                    child: ElevatedButton(
                      child: Text("${_subsProvider.products.firstWhere(
                            (element) => element.id == kSilverSubscriptionId,
                          ).price.toString()} Per Month"),
                      onPressed: () {
                        // Subscribe
                        _subsProvider.connection.buyNonConsumable(
                          purchaseParam: PurchaseParam(
                            productDetails: _products.firstWhere(
                              (element) => element.id == kSilverSubscriptionId,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          // Gold Package
          Card(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Center(
                  child: Text("Gold Package Features"),
                ),
                Text("Share Your Item and Shop Links with Others"),
                Text("Unlimited Branded SMS Messages Per Month"),
                Text("Delivery With Sendy"),
                Text("Unlimited Deals Per Month"),
                Text("Unlimited Product Listings"),
                Text("Inventory Management"),
                Text("Daily Inventory Management Reminders"),
                Container(
                  margin: EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: 50,
                    ),
                    child: ElevatedButton(
                      // child: Text("${_subsProvider.products.firstWhere(
                      //       (element) => element.id == kGoldSubscriptionId,
                      //     ).price.toString()} Per Month"),
                      child: Text("Add Later"),
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
