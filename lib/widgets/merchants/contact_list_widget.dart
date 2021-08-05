import 'package:beammart/models/contact.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/merchants/contact_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactListWidget extends StatelessWidget {
  final Contact? contact;
  final String? contactListId;

  const ContactListWidget({
    Key? key,
    this.contact,
    this.contactListId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Container(
      child: Card(
        child: ListTile(
          title: Text("${contact!.firstName} ${contact!.lastName}"),
          subtitle: Text("${contact!.phoneNumber}"),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_outlined,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Do you really want to delete this contact?',
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // snapshot.data!.docs[index].reference.delete();
                              FirebaseFirestore.instance
                                  .collection('contacts')
                                  .doc(_userProvider.user!.uid)
                                  .collection('contact-list')
                                  .doc(contactListId)
                                  .collection('contact')
                                  .doc(contact!.contactId)
                                  .delete();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Delete',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ContactDetailScreen(
                          contact: contact,
                          contactListId: contactListId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
