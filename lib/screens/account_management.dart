import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/bnpl/past_payments.dart';
import 'package:beammart/screens/bnpl/repay_installment.dart';
import 'package:beammart/screens/bnpl/upcoming_payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountManagement extends StatelessWidget {
  const AccountManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.purple,
              ],
            ),
            borderRadius: BorderRadius.circular(20)),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('bnpl')
                .doc(_userProvider.user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.data!.exists) {
                return Center(
                  child: Text("No Such Document"),
                );
              }
              final _data = snapshot.data!.data();
              if (_data != null) {
                final _totalAmountDue = _data['totalAmountDue'];
                final _accountLimit = _data['accountLimit'];
                final _nextPaymentAmount = _data['nextPaymentAmount'];
                final _nextPaymentDate = _data['nextPaymentDate'];
                return ListView(
                  children: [
                    AccountManagementCardWidget(
                      title: "Total Amount Due",
                      subtitle: "Ksh. $_totalAmountDue",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AccountManagementCardWidget(
                      title: "Account Limit",
                      subtitle: "Ksh. $_accountLimit",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AccountManagementCardWidget(
                      title: "Next Payment Amount",
                      subtitle: "Ksh. $_nextPaymentAmount",
                    ),
                    AccountManagementCardWidget(
                      title: "Next Payment Date",
                      subtitle: "$_nextPaymentDate",
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 50, width: 200),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UpcomingPaymentsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "All Upcoming Payments",
                            style: GoogleFonts.roboto(
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 50, width: 200),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PastPaymentsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "All Past Payments",
                            style: GoogleFonts.roboto(
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.tightFor(height: 50, width: 200),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RepayInfoScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "How To Repay",
                            style: GoogleFonts.roboto(
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: Text("You haven't Signed Up for Buy Now Pay Later Service"),
              );
            }),
      ),
    );
  }
}

class AccountManagementCardWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const AccountManagementCardWidget({
    Key? key,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.blue,
          width: 5,
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "$title",
                style: GoogleFonts.gelasio(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(),
              child: Text(
                "$subtitle",
                style: GoogleFonts.gelasio(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
