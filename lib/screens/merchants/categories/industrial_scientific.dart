import 'package:beammart/enums/industrial_scientific.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/posting_item_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndustrialScientificScreen extends StatefulWidget {
  @override
  _IndustrialScientificScreenState createState() =>
      _IndustrialScientificScreenState();
}

class _IndustrialScientificScreenState
    extends State<IndustrialScientificScreen> {
  bool isExpanded = true;

  IndustrialScientific _industrialScientific =
      IndustrialScientific.abrasiveAndFinishingProducts;

  final _industrialScientificFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Industrial and Scientific';

  String _subCategory = 'Adhesive and Finishing Products';

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  bool _inStock = true;

  bool _sellOnline = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthenticationProvider>(context).user!.uid;
    final _imageUrls = Provider.of<ImageUploadProvider>(context).imageUrls;
    final _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final _categoryTokensProvider =
        Provider.of<CategoryTokensProvider>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);
    final _subsProvider = Provider.of<SubscriptionsProvider>(context);
    _postItem() async {
      if (_industrialScientificFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider
                    .categoryTokens!.industrialScientificTokens !=
                null) {
          final double requiredTokens = _categoryTokensProvider
              .categoryTokens!.industrialScientificTokens!;
          final bool _hasTokens = await checkBalance(_userId, requiredTokens);
          if (_hasTokens) {
            saveItemFirestore(
              context,
              _userId,
              MerchantItem(
                category: _category,
                subCategory: _subCategory,
                images: _imageUrls,
                title: _titleController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                dateAdded: DateTime.now(),
                dateModified: DateTime.now(),
                inStock: _inStock,
                lastRenewal: DateTime.now().toIso8601String(),
                isActive: true,
                sellOnline: _sellOnline,
              ).toJson(),
            );
            _imageUploadProvider.deleteImageUrls();
            _subsProvider.consume(requiredTokens, _userId);
            setState(() {
              _loading = false;
            });
          } else {
            setState(() {
              _loading = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TokensScreen(),
              ),
            );
          }
        }
      } else {
        postingItemErrorUtils(context);
      }
    }

    return (_loading)
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Uploading...'),
              centerTitle: true,
            ),
            body: LinearProgressIndicator(),
          )
        : Scaffold(
            bottomSheet: (_imageUploadProvider.isUploadingImages != null)
                ? (_imageUploadProvider.isUploadingImages!)
                    ? Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.pink,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text("Uploading Product Images..."),
                        ),
                      )
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.pink,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Images Uploaded Successfully"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.cyan,
                              ),
                              onPressed: () {
                                _postItem();
                              },
                              child: Text("Post Item"),
                            ),
                          ],
                        ),
                      )
                : Container(
                    child: Text(""),
                  ),
            appBar: AppBar(
              title: Text('Industrial & Scientific'),
              actions: [
                (_imageUploadProvider.isUploadingImages != null)
                    ? (!_imageUploadProvider.isUploadingImages!)
                        ? TextButton(
                            onPressed: () async {
                              _postItem();
                            },
                            child: Text(
                              'Post Item',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Container()
                    : Container(),
              ],
            ),
            body: Form(
              key: _industrialScientificFormKey,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a title";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Title (required)',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Description (required)',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a price";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Price (required)',
                      ),
                    ),
                  ),
                  MergeSemantics(
                    child: ListTile(
                      title: Text('Item in Stock'),
                      trailing: CupertinoSwitch(
                        value: _inStock,
                        onChanged: (bool value) {
                          setState(() {
                            _inStock = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _inStock = !_inStock;
                        });
                      },
                    ),
                  ),
                   MergeSemantics(
                    child: ListTile(
                      title: Text('Online Ordering'),
                      trailing: CupertinoSwitch(
                        value: _sellOnline,
                        onChanged: (bool value) {
                          setState(() {
                            _sellOnline = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _sellOnline = !_sellOnline;
                        });
                      },
                    ),
                  ),
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title:
                                Text('Industrial & Scientific Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Abrasive & Finishing Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .abrasiveAndFinishingProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .abrasiveAndFinishingProducts;
                                    _subCategory =
                                        'Abrasive and Finishing Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Additive Manufacturing Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .additiveManufacturingProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .additiveManufacturingProducts;
                                    _subCategory =
                                        'Additive Manufacturing Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Commercial Door Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific.commercialDoorProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .commercialDoorProducts;
                                    _subCategory = 'Commercial Door Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cutting Tools'),
                                value: _industrialScientific ==
                                    IndustrialScientific.cuttingTools,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.cuttingTools;
                                    _subCategory = 'Cutting Tools';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fasteners'),
                                value: _industrialScientific ==
                                    IndustrialScientific.fasteners,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.fasteners;
                                    _subCategory = 'Fasteners';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Filtration'),
                                value: _industrialScientific ==
                                    IndustrialScientific.filtration,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.filtration;
                                    _subCategory = 'Filtration';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title:
                                    Text('Food Service Equipment & Supplies'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .foodServiceEquipmentAndSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .foodServiceEquipmentAndSupplies;
                                    _subCategory =
                                        'Food Service Equipment and Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title:
                                    Text('Hydraulics, Pneumatics & Plumbing'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .hydraulicsPneumaticsAndPlumbing,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .hydraulicsPneumaticsAndPlumbing;
                                    _subCategory =
                                        'Hydraulics, Pneumatics and Plumbing';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Industrial Electrical'),
                                value: _industrialScientific ==
                                    IndustrialScientific.industrialElectrical,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .industrialElectrical;
                                    _subCategory = 'Industrial Electrical';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Industrial Hardware'),
                                value: _industrialScientific ==
                                    IndustrialScientific.industrialHardware,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.industrialHardware;
                                    _subCategory = 'Industrial Hardware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Industrial Power & Hand Tools'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .industrialPowerAndHandTools,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .industrialPowerAndHandTools;
                                    _subCategory =
                                        'Industrial Power and Hand Tools';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Janitorial & Sanitation Supplies'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .janitorialAndSanitationSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .janitorialAndSanitationSupplies;
                                    _subCategory =
                                        'Janitorial and Sanitation Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Lab & Scientific Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .labAndScientificProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .labAndScientificProducts;
                                    _subCategory =
                                        'Lab and Scientific Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Material Handling Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .materialHandlingProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .materialHandlingProducts;
                                    _subCategory = 'Material Handling Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Packaging & Shipping Supplies'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .packagingAndShippingSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .packagingAndShippingSupplies;
                                    _subCategory =
                                        'Packaging and Shipping Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Power Transmission Products'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .powerTransmissionProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .powerTransmissionProducts;
                                    _subCategory =
                                        'Power Transmission Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Professional Dental Supplies'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .professionalDentalSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .professionalDentalSupplies;
                                    _subCategory =
                                        'Professional Dental Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Raw Materials'),
                                value: _industrialScientific ==
                                    IndustrialScientific.rawMaterials,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.rawMaterials;
                                    _subCategory = 'Raw Materials';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title:
                                    Text('Retail Store Fixtures & Equipment'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .retailStoreFixturesAndEquipment,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .retailStoreFixturesAndEquipment;
                                    _subCategory =
                                        'Retail Store Fixtures and Equipment';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Robotics'),
                                value: _industrialScientific ==
                                    IndustrialScientific.robotics,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.robotics;
                                    _subCategory = 'Robotics';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Science Education'),
                                value: _industrialScientific ==
                                    IndustrialScientific.scienceEducation,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific =
                                        IndustrialScientific.scienceEducation;
                                    _subCategory = 'Science Education';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Tapes, Adhesives & Sealants'),
                                value: _industrialScientific ==
                                    IndustrialScientific
                                        .tapesAdhesivesAndSealants,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .tapesAdhesivesAndSealants;
                                    _subCategory =
                                        'Tapes, Adhesives and Sealants';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Test, Measure & Inspect'),
                                value: _industrialScientific ==
                                    IndustrialScientific.testMeasureAndInspect,
                                onChanged: (value) {
                                  setState(() {
                                    _industrialScientific = IndustrialScientific
                                        .testMeasureAndInspect;
                                    _subCategory = 'Test, Measure and Inspect';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        isExpanded: isExpanded,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
  }
}
