import 'package:flutter/material.dart';

class ConsumerOrders extends StatelessWidget {
  const ConsumerOrders({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check whether the user is authenticated
    return Scaffold(
      appBar: AppBar(  
        title: Text("Orders"),
      ),
      body: Container(  
        child: ListView(  
          children: [
            // Order Number
            // Order Time
            // Delivered or Not
            // Merchant Name
            // Merchant Profile Link
            // Description
            // Title
            // Item Id
            // Merchant Id
            // Chat with Merchant
            // Driver 
            // Driver Phone Number
            // Delivery Number
            Container()
          ],
        ),
      ),
    );
  }
}