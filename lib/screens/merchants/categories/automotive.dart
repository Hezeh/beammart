import 'package:beammart/enums/automotive.dart';
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

class AutomotiveScreen extends StatefulWidget {
  @override
  _AutomotiveScreenState createState() => _AutomotiveScreenState();
}

class _AutomotiveScreenState extends State<AutomotiveScreen> {
  bool isExpanded = true;

  Automotive _automotive = Automotive.autoBuying;

  final _automotiveFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Automotive';

  String _subCategory = 'Auto Buying';

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
      if (_automotiveFormKey.currentState!.validate()) {
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
              title: Text('Automotive'),
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
              key: _automotiveFormKey,
              child: ListView(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (int index, bool _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Auto Buying'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.autoBuying,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.autoBuying;
                                  _subCategory = 'Auto Buying';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Auto Services'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.autoServices,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.autoServices;
                                  _subCategory = 'Auto Services';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Car Care'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.carCare,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.carCare;
                                  _subCategory = 'Car Care';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Car Electronics'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.carElectronics,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.carElectronics;
                                  _subCategory = 'Car Electronics';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Exterior Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.exteriorAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.exteriorAccessories;
                                  _subCategory = 'Exterior Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Interior Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.interiorAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.interiorAccessories;
                                  _subCategory = 'Interior Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Lights & Lighting Accessories'),
                              selectedColor: Colors.pink,
                              selected: _automotive ==
                                  Automotive.lightsAndlightingAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive =
                                      Automotive.lightsAndlightingAccessories;
                                  _subCategory =
                                      'Lights and Lighting Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Motorcycle & Powersports'),
                              selectedColor: Colors.pink,
                              selected: _automotive ==
                                  Automotive.motocycleAndPowerSports,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive =
                                      Automotive.motocycleAndPowerSports;
                                  _subCategory = 'Motorcycle and Powersports';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Oils & Fluids'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.oilsAndFluids,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.oilsAndFluids;
                                  _subCategory = 'Oils and Fluids';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Paint & Paint Supplies'),
                              selectedColor: Colors.pink,
                              selected: _automotive ==
                                  Automotive.paintAndpaintSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive =
                                      Automotive.paintAndpaintSupplies;
                                  _subCategory = 'Paint and Paint Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Replacement Parts'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.replacementParts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.replacementParts;
                                  _subCategory = 'Replacement Parts';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Performace Parts & Accessories'),
                              selectedColor: Colors.pink,
                              selected: _automotive ==
                                  Automotive.performacePartsAndAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive =
                                      Automotive.performacePartsAndAccessories;
                                  _subCategory =
                                      'Performance Parts and Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('RV Parts'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.rvParts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.rvParts;
                                  _subCategory = 'RV Parts';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Tires & Wheels'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.tiresAndWheels,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.tiresAndWheels;
                                  _subCategory = 'Tires and Wheels';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Tools & Equipment'),
                              selectedColor: Colors.pink,
                              selected:
                                  _automotive == Automotive.toolsAndEquipment,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.toolsAndEquipment;
                                  _subCategory = 'Tools and Equipment';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Heavy Duty'),
                              selectedColor: Colors.pink,
                              selected: _automotive == Automotive.heavyDuty,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive = Automotive.heavyDuty;
                                  _subCategory = 'Heavy Duty';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Commercial Vehicle Equipment'),
                              selectedColor: Colors.pink,
                              selected: _automotive ==
                                  Automotive.commercialVehicleEquipment,
                              onSelected: (bool selected) {
                                setState(() {
                                  _automotive =
                                      Automotive.commercialVehicleEquipment;
                                  _subCategory = 'Commercial Vehicle Equipment';
                                });
                              },
                            ),
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
