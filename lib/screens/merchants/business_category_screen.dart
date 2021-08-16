import 'package:beammart/screens/merchants/profile_screen.dart';
import 'package:beammart/screens/merchants/service_category_screen.dart';
import 'package:flutter/material.dart';

class BusinessCategoryScreen extends StatelessWidget {
  const BusinessCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Business Category"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Which Business Type Do You Operate?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Container(
            child: ElevatedButton(
              child: Text("Product-Based Business"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      isServiceBusiness: false,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            child: ElevatedButton(
              child: Text("Services-Based Business"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServiceCategoryScreen(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
