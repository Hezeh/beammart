import 'package:beammart/models/order.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/services/orders_service.dart';
import 'package:beammart/widgets/consumer_order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerOrders extends StatelessWidget {
  const ConsumerOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    // Check whether the user is authenticated
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      // body: Container(
      //   child: ListView(
      //     children: [
      //       // Order Number
      //       // Order Time
      //       // Delivered or Not
      //       // Merchant Name
      //       // Merchant Profile Link
      //       // Description
      //       // Title
      //       // Item Id
      //       // Merchant Id
      //       // Chat with Merchant
      //       // Driver
      //       // Driver Phone Number
      //       // Delivery Number
      //       Container()
      //     ],
      //   ),
      // ),
      body: StreamBuilder<List<Order>>(
          stream: getUserOrders(_authProvider.user!.uid),
          builder: (context, AsyncSnapshot<List<Order?>> snapshot) {
            if (snapshot.data == null) {
              return LinearProgressIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("You Have No Orders Yet"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // ignore: unnecessary_null_comparison
                return ConsumerOrderCard(
                  imageUrl: snapshot.data![index]!.item!.images!.first,
                  itemId: snapshot.data![index]!.item!.itemId,
                  itemQuantity: snapshot.data![index]!.quantity,
                  itemTitle: snapshot.data![index]!.item!.title,
                  merchantName: snapshot.data![index]!.item!.businessName,
                  orderTotalAmount: snapshot.data![index]!.totalOrderAmount,
                );
              },
            );
          }),
    );
  }
}
