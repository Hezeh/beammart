import 'package:beammart/models/contact.dart';
import 'package:beammart/screens/merchants/contact_detail_screen.dart';
import 'package:flutter/material.dart';

class ContactListWidget extends StatelessWidget {
  final Contact? contact;
  final String? contactId;

  const ContactListWidget({
    Key? key,
    this.contact,
    this.contactId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text("${contact!.firstName} ${contact!.lastName}"),
          subtitle: Text("${contact!.phoneNumber}"),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ContactDetailScreen(
                    contact: contact,
                    contactId: contactId,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
