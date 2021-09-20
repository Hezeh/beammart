import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingPaymentsScreen extends StatelessWidget {
  const UpcomingPaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    if (_authProvider.user != null) {
      final _dbRef = FirebaseFirestore.instance
          .collection('upcoming-payments')
          .doc(_authProvider.user!.uid)
          .collection('transactions');
      return Scaffold(
        appBar: AppBar(
          title: Text("Upcoming Payments"),
        ),
        body: StreamBuilder(
          stream: _dbRef.snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("An Unexpected Error Occurred"),
              );
            }
            if (snapshot.data!.size == 0) {
              return Center(
                child: Text("No Upcoming Payments"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final _amount = snapshot.data!.docs[index].data()['amount'];
                final _date = snapshot.data!.docs[index].data()['date'];
                return ListTile(
                  title: Text("$_amount"),
                  subtitle: Text("$_date"),
                );
              },
            );
          },
        ),
      );
    } else {
      return LoginScreen(
        showCloseIcon: true,
      );
    }
  }
}
