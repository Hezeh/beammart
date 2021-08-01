import 'package:beammart/models/contact_list.dart';
import 'package:beammart/screens/merchants/contact_detail_screen.dart';
import 'package:beammart/widgets/merchants/contact_list_widget.dart';
import 'package:flutter/material.dart';

class ContactListScreen extends StatelessWidget {
  final ContactList? contactList;

  const ContactListScreen({
    Key? key,
    this.contactList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactDetailScreen(
                contactId: contactList!.contactId,
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
      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: contactList!.contacts!.length,
            itemBuilder: (context, index) {
              return ContactListWidget(
                contactId: contactList!.contactId,
                contact: contactList!.contacts![index],
              );
            },
          ),
        ],
      ),
    );
  }
}
