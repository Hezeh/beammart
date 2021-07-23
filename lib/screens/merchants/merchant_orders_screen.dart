import 'package:flutter/material.dart';

class MerchantOrdersScreen extends StatelessWidget {
  const MerchantOrdersScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text("Merchant Orders"),
        bottom: TabBar(  
          tabs: [
            Tab(
                icon: Icon(
                  Icons.edit_outlined,
                ),
                child: Semantics(
                  child: Text('New Orders'),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.analytics_outlined,
                ),
                child: Semantics(
                  child: Text('Past Orders'),
                ),
              ),
          ],
        ),
      ),
      body: TabBarView(  
        children: [
          Container(),
          Container()
        ],
      ),
    );
  }
}