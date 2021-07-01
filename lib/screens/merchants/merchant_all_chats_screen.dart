import 'package:beammart/widgets/merchants/merchant_all_chats_widget.dart';
import 'package:flutter/material.dart';

class MerchantAllChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text("Your Chats"),
        centerTitle: true,
      ),
      body: MerchantAllChatsWidget()
    );
  }
}