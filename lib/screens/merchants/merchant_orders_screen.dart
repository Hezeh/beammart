import 'package:beammart/models/order.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/widgets/merchant_order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MerchantOrdersScreen extends StatefulWidget {
  const MerchantOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MerchantOrdersScreen> createState() => _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends State<MerchantOrdersScreen> {
  String _groupValue = "New-Orders";
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Merchant Orders"),
      ),
      body: ListView(
        children: [
          Container(
            child: CupertinoSegmentedControl<String>(
              borderColor: Colors.white,
              selectedColor: Colors.pink,
              padding: EdgeInsets.all(10),
              groupValue: _groupValue,
              onValueChanged: (value) {
                setState(() {
                  _groupValue = value;
                });
              },
              children: {
                "New-Orders": Text("New Orders"),
                "Past-Orders": Text("Past Orders"),
              },
            ),
          ),
          (_groupValue == 'New-Orders')
              ? Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('profile')
                        .doc(_userProvider.user!.uid)
                        .collection('orders')
                        .where('delivered', isEqualTo: false)
                        .orderBy('orderTimestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("No Orders"),
                        );
                      }
                      if (snapshot.data != null && snapshot.data!.size == 0) {
                        return Center(
                          child: Text("No New Orders"),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.size,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final _json = snapshot.data!.docs[0].data();
                          final _order = Order.fromJson(_json);
                          return MerchantOrderCard(
                            order: _order,
                          );
                        },
                      );
                    },
                  ),
                )
              : Container(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('profile')
                        .doc(_userProvider.user!.uid)
                        .collection('orders')
                        .where('delivered', isEqualTo: true)
                        .orderBy('orderTimestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("No Orders"),
                        );
                      }
                      if (snapshot.data != null && snapshot.data!.size == 0) {
                        return Center(
                          child: Text("No Past Orders"),
                        );
                      }

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final _json = snapshot.data!.docs[0].data();
                          final _order = Order.fromJson(_json);
                          return MerchantOrderCard(
                            order: _order,
                          );
                        },
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
