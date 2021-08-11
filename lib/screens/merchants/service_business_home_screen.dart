import 'package:beammart/models/service_detail.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/merchant_service_detail.dart';
import 'package:beammart/widgets/merchants/merchant_left_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ServiceBusinessHomeScreen extends StatefulWidget {
  const ServiceBusinessHomeScreen({Key? key}) : super(key: key);

  @override
  State<ServiceBusinessHomeScreen> createState() =>
      _ServiceBusinessHomeScreenState();
}

class _ServiceBusinessHomeScreenState extends State<ServiceBusinessHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: LeftDrawer(),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Business Home"),
        leading: IconButton(
          icon: Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            tooltip: "Back",
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Add New Service',
        icon: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.pink,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MerchantServiceDetailScreen(),
            ),
          );
        },
        label: Text(
          "Add New Service",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('profile')
                .doc(_userProvider.user!.uid)
                .collection('services')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text("You have No Services Yet"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.size,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final _serviceDetails =
                      ServiceDetail.fromJson(snapshot.data!.docs[index].data());
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MerchantServiceDetailScreen(
                            serviceDetail: _serviceDetails,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${_serviceDetails.serviceName}"),
                        subtitle: Text("${_serviceDetails.serviceDescription}"),
                        trailing: Text("${_serviceDetails.servicePrice}"),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
