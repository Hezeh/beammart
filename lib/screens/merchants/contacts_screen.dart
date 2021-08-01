import 'package:beammart/models/contact_list.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/services/contacts_service.dart';
import 'package:beammart/widgets/merchants/single_contact_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _listNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _listNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Contacts"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                  child: Text("Create New List"),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _listNameController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await createContactList(
                          _userProvider.user!.uid,
                          _listNameController.text,
                        );
                      }
                      _formKey.currentState!.reset();
                      _listNameController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _listNameController,
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(10),
                          labelText: 'List Name',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        label: Text("Create New List"),
        icon: Icon(
          Icons.create,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          FutureBuilder<List<ContactList?>?>(
            future: getContactsLists(_userProvider.user!.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                // print()
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return SingleContactListWidget(
                    contactList: snapshot.data![index],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
