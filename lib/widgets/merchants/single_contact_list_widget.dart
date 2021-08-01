import 'package:beammart/models/contact_list.dart';
import 'package:beammart/screens/merchants/contact_list_screen.dart';
import 'package:flutter/material.dart';

class SingleContactListWidget extends StatelessWidget {
  final ContactList? contactList;

  const SingleContactListWidget({
    Key? key,
    this.contactList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            trailing: Text("${contactList!.contacts!.length}"),
          ),
        ),
      ),
    );
  }
}
