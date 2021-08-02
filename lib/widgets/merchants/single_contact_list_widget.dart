import 'package:beammart/models/contact_list.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/contact_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleContactListWidget extends StatelessWidget {
  final ContactList? contactList;

  const SingleContactListWidget({
    Key? key,
    this.contactList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ContactListScreen(
              contactList: contactList,
            ),
          ),
        );
      },
      child: Card(
        child: Container(
          child: ListTile(
            title: Text("${contactList!.listName}"),
            trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('contacts')
                  .doc(_userProvider.user!.uid)
                  .collection('contact-list')
                  .doc(contactList!.contactListId)
                  .collection('contact')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("");
                }
                return Text("${snapshot.data!.size}");
              },
            ),
          ),
        ),
      ),
    );
  }
}
