import 'package:beammart/providers/add_business_profile_provider.dart';
import 'package:beammart/screens/merchants/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCategoryScreen extends StatelessWidget {
  const ServiceCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _addBusinessProvider =
        Provider.of<AddBusinessProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Category"),
      ),
      // Change to GridView
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('services').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final _serviceId = snapshot.data!.docs[index].id;
              final _serviceType =
                  snapshot.data!.docs[index].data()['serviceName'];
              final _serviceDescription =
                  snapshot.data!.docs[index].data()['description'];
              return InkWell(
                onTap: () {
                  _addBusinessProvider.addService(_serviceType, _serviceId);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                       builder: (_) => ProfileScreen(),
                    ),
                  );
                },
                child: ListTile(
                  title: Text("$_serviceType"),
                  subtitle: Text("$_serviceDescription"),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
