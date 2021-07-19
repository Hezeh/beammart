import 'package:beammart/models/order.dart';
import 'package:flutter/material.dart';

class ConsumerOrderDetailScreen extends StatelessWidget {
  final Order? order;
  const ConsumerOrderDetailScreen({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: ListView(  
        children: [
          // About the Order
          Card(  
            // child: ,
          )
          // Merchant 
          // Delivery Time
        ],
      ),
    );
  }
}
