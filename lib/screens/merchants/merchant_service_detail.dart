import 'package:beammart/models/service_detail.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/services/merchant_business_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MerchantServiceDetailScreen extends StatefulWidget {
  final ServiceDetail? serviceDetail;
  final String? docId;

  const MerchantServiceDetailScreen({
    Key? key,
    this.serviceDetail,
    this.docId,
  }) : super(key: key);

  @override
  State<MerchantServiceDetailScreen> createState() =>
      _MerchantServiceDetailScreenState();
}

class _MerchantServiceDetailScreenState
    extends State<MerchantServiceDetailScreen> {
  final _serviceFormKey = GlobalKey<FormState>();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _serviceDescriptionController = TextEditingController();
  TextEditingController _servicePriceController = TextEditingController();

  String _groupValue = 'One-Time';

  @override
  void initState() {
    super.initState();
    if (widget.serviceDetail != null) {
      _serviceNameController.text = widget.serviceDetail!.serviceName!;
      _serviceDescriptionController.text =
          widget.serviceDetail!.serviceDescription!;
      _servicePriceController.text =
          widget.serviceDetail!.servicePrice.toString();
      _groupValue = widget.serviceDetail!.servicePriceType!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _serviceNameController.dispose();
    _serviceDescriptionController.dispose();
    _servicePriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Service Detail"), actions: [
        (widget.serviceDetail != null)
            ? IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Do you really want to delete this service?',
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('profile')
                                  .doc(_userProvider.user!.uid)
                                  .collection('services')
                                  .doc(widget.docId)
                                  .delete();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Delete',
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.delete_outline_outlined,
                ),
              )
            : SizedBox.shrink()
      ]),
      body: Form(
        key: _serviceFormKey,
        child: ListView(
          children: [
            // Service Name
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _serviceNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a service name";
                  }
                  return null;
                },
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
                  labelText: 'Service Name (Required)',
                ),
              ),
            ),
            // Service Description
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _serviceDescriptionController,
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 4,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Service Description (Optional)',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  "Payment Type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            // Service Pricing, Hourly or One-Time
            CupertinoSegmentedControl<String>(
              borderColor: Colors.pink,
              padding: EdgeInsets.all(10),
              selectedColor: Colors.pink,
              groupValue: _groupValue,
              children: {
                'One-Time': Text("One-Time"),
                'Hourly': Text("Hourly"),
              },
              onValueChanged: (value) {
                setState(() {
                  _groupValue = value;
                });
              },
            ),
            // Service Price
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _servicePriceController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a price";
                  }
                  return null;
                },
                autocorrect: true,
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: (_groupValue == 'Hourly')
                      ? Text("/Hr")
                      : Text("/Service"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Service Price (Required)',
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onPressed: () async {
                  if (_serviceFormKey.currentState!.validate()) {
                    createNewBusinessService(
                      serviceName: _serviceNameController.text,
                      serviceDescription: _serviceDescriptionController.text,
                      servicePrice: double.parse(_servicePriceController.text),
                      servicePriceType: _groupValue,
                      userId: _userProvider.user!.uid,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Create Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
