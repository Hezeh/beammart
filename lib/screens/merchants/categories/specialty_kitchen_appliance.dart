import 'package:beammart/enums/specialty_kitchen_appliances.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/screens/merchants/uploading_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/posting_item_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialtyKitchenAppliancesScreen extends StatefulWidget {
  const SpecialtyKitchenAppliancesScreen({Key? key}) : super(key: key);

  @override
  _SpecialtyKitchenAppliancesScreenState createState() =>
      _SpecialtyKitchenAppliancesScreenState();
}

class _SpecialtyKitchenAppliancesScreenState
    extends State<SpecialtyKitchenAppliancesScreen> {
  SpecialtyKitchenAppliances _specialtyKitchenAppliances =
      SpecialtyKitchenAppliances.breadMakers;

  bool isExpanded = true;

  final _specialtyKitchenAppliancesFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Special Kitchen Appliances';

  String _subCategory = 'Bread Makers';

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
      if (_specialtyKitchenAppliancesFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider
                    .categoryTokens!.specialtyKitchenApplianceTokens !=
                null) {
          final double requiredTokens = _categoryTokensProvider
              .categoryTokens!.specialtyKitchenApplianceTokens!;
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
        ? UploadingScreen()
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
              title: Text('Specialty Kitchen Appliances'),
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
              key: _specialtyKitchenAppliancesFormKey,
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
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(
                                'Specialty Kitchen Appliances Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bread Makers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.breadMakers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances.breadMakers;
                                    _subCategory = 'Bread Makers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Vacuum Sealers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.vacuumSealers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .vacuumSealers;
                                    _subCategory = 'Vacuum Sealers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Food Warmers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.foodWarmers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances.foodWarmers;
                                    _subCategory = 'Food Warmers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Food Dehydrators'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.foodDehydrators,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .foodDehydrators;
                                    _subCategory = 'Food Dehydrators';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cooktops and Burners'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances
                                        .cooktopsAndBurners,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .cooktopsAndBurners;
                                    _subCategory = 'Cooktops and Burners';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fondue Pots'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.fonduePots,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances.fonduePots;
                                    _subCategory = 'Fondue Pots';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Egg Cookers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.eggCookers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances.eggCookers;
                                    _subCategory = 'Egg Cookers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Food Saver Vacuum Sealers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances
                                        .foodSaverVacuumSealers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .foodSaverVacuumSealers;
                                    _subCategory = 'Food Saver Vacuum Sealers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Hotdog Warmers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.hotDogWarmers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .hotDogWarmers;
                                    _subCategory = 'Hotdog Warmers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Pizza Makers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.pizzaMakers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances.pizzaMakers;
                                    _subCategory = 'Pizza Makers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Quesadilla Makers'),
                                value: _specialtyKitchenAppliances ==
                                    SpecialtyKitchenAppliances.quesadillaMakers,
                                onChanged: (value) {
                                  setState(() {
                                    _specialtyKitchenAppliances =
                                        SpecialtyKitchenAppliances
                                            .quesadillaMakers;
                                    _subCategory = 'Quesadilla Makers';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        isExpanded: isExpanded,
                      ),
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
