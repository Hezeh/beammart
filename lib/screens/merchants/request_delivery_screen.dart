import 'package:beammart/models/order.dart';
import 'package:flutter/material.dart';

class RequestDeliveryDriver extends StatelessWidget {
  final Order? order;
  
  const RequestDeliveryDriver({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Delivery"),
      ),
      body: ListView(  
        children: [
          Container(),
        ],
      ),
    );
  }
}
