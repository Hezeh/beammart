import 'package:beammart/enums/industrial_scientific.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tokens_screen.dart';

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
            _categoryTokensProvider.categoryTokens!.electronicsTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.electronicsTokens!;
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
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Abrasive & Finishing Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .abrasiveAndFinishingProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .abrasiveAndFinishingProducts;
                                  _subCategory =
                                      'Abrasive and Finishing Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Additive Manufacturing Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .additiveManufacturingProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .additiveManufacturingProducts;
                                  _subCategory =
                                      'Additive Manufacturing Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Commercial Door Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.commercialDoorProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .commercialDoorProducts;
                                  _subCategory = 'Commercial Door Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Cutting Tools'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.cuttingTools,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific =
                                      IndustrialScientific.cuttingTools;
                                  _subCategory = 'Cutting Tools';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Fasteners'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.fasteners,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific =
                                      IndustrialScientific.fasteners;
                                  _subCategory = 'Fasteners';
                                });
                              },
                            ),
                            // ChoiceChip(
                            //   label: Text('Filtration'),
                            //   selectedColor: Colors.pink,
                            //   selected: _industrialScientific ==
                            //       IndustrialScientific.filtration,
                            //   onSelected: (bool selected) {
                            //     setState(() {
                            //       _industrialScientific =
                            //           IndustrialScientific.filtration;
                            //       _subCategory = 'Filtration';
                            //     });
                            //   },
                            // ),
                            ChoiceChip(
                              label: Text('Food Service Equipment & Supplies'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .foodServiceEquipmentAndSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .foodServiceEquipmentAndSupplies;
                                  _subCategory =
                                      'Food Service Equipment and Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Hydraulics, Pneumatics & Plumbing'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .hydraulicsPneumaticsAndPlumbing,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .hydraulicsPneumaticsAndPlumbing;
                                  _subCategory =
                                      'Hydraulics, Pneumatics and Plumbing';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Industrial Electrical'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.industrialElectrical,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific =
                                      IndustrialScientific.industrialElectrical;
                                  _subCategory = 'Industrial Electrical';
                                });
                              },
                            ),
                            // ChoiceChip(
                            //   label: Text('Industrial Hardware'),
                            //   selectedColor: Colors.pink,
                            //   selected: _industrialScientific ==
                            //       IndustrialScientific.industrialHardware,
                            //   onSelected: (bool selected) {
                            //     setState(() {
                            //       _industrialScientific =
                            //           IndustrialScientific.industrialHardware;
                            //       _subCategory = 'Industrial Hardware';
                            //     });
                            //   },
                            // ),
                            ChoiceChip(
                              label: Text('Industrial Power & Hand Tools'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .industrialPowerAndHandTools,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .industrialPowerAndHandTools;
                                  _subCategory =
                                      'Industrial Power and Hand Tools';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Janitorial & Sanitation Supplies'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .janitorialAndSanitationSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .janitorialAndSanitationSupplies;
                                  _subCategory =
                                      'Janitorial and Sanitation Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Lab & Scientific Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.labAndScientificProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .labAndScientificProducts;
                                  _subCategory = 'Lab and Scientific Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Material Handling Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.materialHandlingProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .materialHandlingProducts;
                                  _subCategory = 'Material Handling Products';
                                });
                              },
                            ),
                            // ChoiceChip(
                            //   label: Text('Occupational Health'),
                            //   selectedColor: Colors.pink,
                            //   selected: _industrialScientific ==
                            //       IndustrialScientific.occupationalHealth,
                            //   onSelected: (bool selected) {
                            //     setState(() {
                            //       _industrialScientific =
                            //           IndustrialScientific.occupationalHealth;
                            //       _subCategory = 'Occupational Health';
                            //     });
                            //   },
                            // ),
                            ChoiceChip(
                              label: Text('Packaging & Shipping Supplies'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .packagingAndShippingSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .packagingAndShippingSupplies;
                                  _subCategory =
                                      'Packaging and Shipping Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Power Transmission Products'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .powerTransmissionProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .powerTransmissionProducts;
                                  _subCategory = 'Power Transmission Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Professional Dental Supplies'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .professionalDentalSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .professionalDentalSupplies;
                                  _subCategory = 'Professional Dental Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Raw Materials'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.rawMaterials,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific =
                                      IndustrialScientific.rawMaterials;
                                  _subCategory = 'Raw Materials';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Retail Store Fixtures & Equipment'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .retailStoreFixturesAndEquipment,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .retailStoreFixturesAndEquipment;
                                  _subCategory =
                                      'Retail Store Fixtures and Equipment';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Robotics'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific.robotics,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific =
                                      IndustrialScientific.robotics;
                                  _subCategory = 'Robotics';
                                });
                              },
                            ),
                            // ChoiceChip(
                            //   label: Text('Science Education'),
                            //   selectedColor: Colors.pink,
                            //   selected: _industrialScientific ==
                            //       IndustrialScientific.scienceEducation,
                            //   onSelected: (bool selected) {
                            //     setState(() {
                            //       _industrialScientific =
                            //           IndustrialScientific.scienceEducation;
                            //       _subCategory = 'Science Education';
                            //     });
                            //   },
                            // ),
                            ChoiceChip(
                              label: Text('Tapes, Adhesives & Sealants'),
                              selectedColor: Colors.pink,
                              selected: _industrialScientific ==
                                  IndustrialScientific
                                      .tapesAdhesivesAndSealants,
                              onSelected: (bool selected) {
                                setState(() {
                                  _industrialScientific = IndustrialScientific
                                      .tapesAdhesivesAndSealants;
                                  _subCategory =
                                      'Tapes, Adhesives and Sealants';
                                });
                              },
                            ),
                            // ChoiceChip(
                            //   label: Text('Test, Measure & Inspect'),
                            //   selectedColor: Colors.pink,
                            //   selected: _industrialScientific ==
                            //       IndustrialScientific.testMeasureAndInspect,
                            //   onSelected: (bool selected) {
                            //     setState(() {
                            //       _industrialScientific = IndustrialScientific
                            //           .testMeasureAndInspect;
                            //       _subCategory = 'Test, Measure and Inspect';
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        isExpanded: isExpanded,
                      )
                    ],
                  ),
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
  }
}
