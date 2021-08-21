import 'package:beammart/models/contact.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/contact_info_provider.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ContactInfoScreen extends StatefulWidget {
  final Contact? contact;

  const ContactInfoScreen({Key? key, this.contact}) : super(key: key);

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _contactFormKey = GlobalKey<FormState>();
  PhoneNumber? _phoneNumber;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  _parsePhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
    String parsableNumber = number.parseNumber();
    _phoneNumberController.text = parsableNumber;
  }

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _parsePhoneNumber("${widget.contact!.phoneNumber!}");

      _firstNameController.text = widget.contact!.firstName!;
      _lastNameController.text = widget.contact!.lastName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    final _contactInfoProvider = Provider.of<ContactInfoProvider>(context);
    if (_userProvider.user == null) {
      return LoginScreen(
        showCloseIcon: true,
      );
    }
    return Scaffold(
      persistentFooterButtons: [
        (widget.contact != null)
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: ElevatedButton(
                  child: Text("Edit Contact Info"),
                  onPressed: () async {
                    if (_contactFormKey.currentState!.validate()) {
                      final _data = Contact(
                        contactId: widget.contact!.contactId,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phoneNumber: _phoneNumber!.phoneNumber,
                      );
                      final _docRef = FirebaseFirestore.instance
                          .collection('consumers')
                          .doc(_userProvider.user!.uid);

                      _docRef.set(
                        {
                          'contactInfo': _data.toJson(),
                        },
                        SetOptions(
                          merge: true,
                        ),
                      );
                      _contactInfoProvider
                          .getConsumerContactInfo(_userProvider.user);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
            : ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: ElevatedButton(
                  child: Text("Save Contact Info"),
                  onPressed: () {
                    if (_contactFormKey.currentState!.validate()) {
                      final _contactId = Uuid().v4();
                      final _data = Contact(
                        contactId: _contactId,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phoneNumber: _phoneNumber!.phoneNumber,
                      );
                      final _docRef = FirebaseFirestore.instance
                          .collection('consumers')
                          .doc(_userProvider.user!.uid);

                      _docRef.set(
                        {
                          'contactInfo': _data.toJson(),
                        },
                        SetOptions(
                          merge: true,
                        ),
                      );
                      _contactInfoProvider
                          .getConsumerContactInfo(_userProvider.user);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              )
      ],
      appBar: AppBar(
        title: Text("Contact Info"),
      ),
      body: Form(
        key: _contactFormKey,
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
            InternationalPhoneNumberInput(
              // countries: _countries,
              onInputChanged: (PhoneNumber number) {
                // print(number.phoneNumber);
                setState(() {
                  _phoneNumber = number;
                });
              },
              onInputValidated: (bool value) {
                // print(value);
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              textFieldController: _phoneNumberController,
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
              onSaved: (PhoneNumber number) {
                // print('On Saved: $number');
              },
              searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
