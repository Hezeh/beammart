import 'package:beammart/models/contact_list.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/merchants_home_screen.dart';
import 'package:beammart/services/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PickContactListScreen extends StatefulWidget {
  final String? message;
  const PickContactListScreen({Key? key, this.message}) : super(key: key);

  @override
  State<PickContactListScreen> createState() => _PickContactListScreenState();
}

class _PickContactListScreenState extends State<PickContactListScreen> {
  String? groupValue;
  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      persistentFooterButtons: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: ElevatedButton(
            onPressed: () {
              if (groupValue != null) {
                sendMerchantMarketingMessage(
                  listId: groupValue,
                  message: widget.message,
                  userId: _userProvider.user!.uid,
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => MerchantHomeScreen(),
                  ),
                  ModalRoute.withName('/'),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "😥 You need to choose contacts to message",
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Text("Send"),
          ),
        ),
      ],
      appBar: AppBar(
        title: Text("Pick Contact List"),
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('contacts')
            .doc(_userProvider.user!.uid)
            .collection('contact-list')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.purple,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "You have no contacts",
                  style: GoogleFonts.gelasio(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final _contactList = ContactList.fromJson(
                snapshot.data!.docs[index].data(),
              );
              return RadioListTile<String?>(
                  title: Text("${_contactList.listName}"),
                  value: _contactList.contactListId,
                  groupValue: groupValue,
                  onChanged: (newValue) {
                    setState(() {
                      groupValue = newValue;
                    });
                  });
            },
          );
        },
      )),
    );
  }
}
