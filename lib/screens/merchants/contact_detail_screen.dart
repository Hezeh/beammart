import 'package:beammart/models/contact.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/services/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ContactDetailScreen extends StatefulWidget {
  final String? contactListId;
  final Contact? contact;

  const ContactDetailScreen({
    Key? key,
    this.contact,
    this.contactListId,
  }) : super(key: key);

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final _contactDetailFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.contact != null) {
      _firstNameController.text = widget.contact!.firstName!;
      _lastNameController.text = widget.contact!.lastName!;
      _phoneNumberController.text = widget.contact!.phoneNumber!;
      _emailAddressController.text = widget.contact!.emailAddress!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      persistentFooterButtons: [
        (widget.contact != null)
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_contactDetailFormKey.currentState!.validate()) {
                      editSingleContactInList(
                        widget.contactListId,
                        _userProvider.user!.uid,
                        Contact(
                          contactId: widget.contact!.contactId,
                          emailAddress: _emailAddressController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phoneNumber: _phoneNumberController.text,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: ElevatedButton(
                  child: Text("Create Contact"),
                  onPressed: () {
                    final _contactId = Uuid().v4();
                    if (_contactDetailFormKey.currentState!.validate()) {
                      addSingleContactToList(
                        widget.contactListId,
                        _userProvider.user!.uid,
                        Contact(
                          contactId: _contactId,
                          emailAddress: _emailAddressController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phoneNumber: _phoneNumberController.text,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
      ],
      appBar: (widget.contact != null)
          ? AppBar(
              title: Text("${widget.contact!.firstName}"),
            )
          : AppBar(
              title: Text("New Contact"),
            ),
      body: Form(
        key: _contactDetailFormKey,
        child: ListView(
          children: [
            // First Name
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _firstNameController,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'First Name',
                ),
              ),
            ),
            // Last Name
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _lastNameController,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Last Name',
                ),
              ),
            ),
            // Phone Number
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _phoneNumberController,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            // Email
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailAddressController,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Email Address',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
