import 'package:beammart/models/contact.dart';
import 'package:beammart/models/contact_list.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/contact_detail_screen.dart';
import 'package:beammart/widgets/merchants/contact_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListScreen extends StatelessWidget {
  final ContactList? contactList;

  const ContactListScreen({
    Key? key,
    this.contactList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactDetailScreen(
                contactListId: contactList!.contactListId,
              ),
            ),
          );
        },
        label: Text("Add Contact"),
        icon: Icon(
          Icons.add_outlined,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: (contactList != null)
            ? Text("${contactList!.listName}")
            : Text("Contact List"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('contacts')
              .doc(_userProvider.user!.uid)
              .collection('contact-list')
              .doc(contactList!.contactListId)
              .collection('contact')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: Text("No Contacts"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final _contact =
                    Contact.fromJson(snapshot.data!.docs[index].data());

                return ContactListWidget(
                  contactListId: contactList!.contactListId,
                  contact: _contact,
                );
              },
            );
          }),
    );
  }
}
