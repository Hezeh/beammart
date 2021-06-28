import 'package:beammart/enums/health_household.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tokens_screen.dart';

class HealthHouseholdScreen extends StatefulWidget {
  @override
  _HealthHouseholdScreenState createState() => _HealthHouseholdScreenState();
}

class _HealthHouseholdScreenState extends State<HealthHouseholdScreen> {
  HealthHousehold _healthHousehold = HealthHousehold.babyAndChildCare;

  final _healthHouseholdFormKey = GlobalKey<FormState>();

  bool isExpanded = true;

  bool _loading = false;

  final String _category = 'Health and Household';

  String _subCategory = 'Baby and Childcare';

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
      if (_healthHouseholdFormKey.currentState!.validate()) {
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
              title: Text('Health & Household'),
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
              key: _healthHouseholdFormKey,
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
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('Health & Household Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Baby & Childcare'),
                                value: _healthHousehold ==
                                    HealthHousehold.babyAndChildCare,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.babyAndChildCare;
                                    _subCategory = 'Baby and Childcare';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Household Supplies'),
                                value: _healthHousehold ==
                                    HealthHousehold.householdSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.householdSupplies;
                                    _subCategory = 'Household Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Medical Supplies & Equipment'),
                                value: _healthHousehold ==
                                    HealthHousehold.medicalSuppliesAndEquipment,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold = HealthHousehold
                                        .medicalSuppliesAndEquipment;
                                    _subCategory =
                                        'Medical Supplies and Equipment';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Sexual Wellness'),
                                value: _healthHousehold ==
                                    HealthHousehold.sexualWellness,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.sexualWellness;
                                    _subCategory = 'Sexual Wellness';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Sports & Nutrition'),
                                value: _healthHousehold ==
                                    HealthHousehold.sportsNutrition,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.sportsNutrition;
                                    _subCategory = 'Sports and Nutrition';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Stationery & Gift Wrapping'),
                                value: _healthHousehold ==
                                    HealthHousehold.stationeryAndGiftWrapping,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold = HealthHousehold
                                        .stationeryAndGiftWrapping;
                                    _subCategory =
                                        'Stationery and Gift Wrapping';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Vision Care'),
                                value: _healthHousehold ==
                                    HealthHousehold.visionCare,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.visionCare;
                                    _subCategory = 'Vision Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Vitamins & Dietary Supplements'),
                                value: _healthHousehold ==
                                    HealthHousehold
                                        .vitaminsAndDietarySupplements,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold = HealthHousehold
                                        .vitaminsAndDietarySupplements;
                                    _subCategory =
                                        'Vitamins and Dietary Supplements';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Wellness & Relaxation'),
                                value: _healthHousehold ==
                                    HealthHousehold.wellnessAndRelaxation,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.wellnessAndRelaxation;
                                    _subCategory = 'Wellness and Relaxation';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Feminine Care'),
                                value: _healthHousehold ==
                                    HealthHousehold.feminineCare,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.feminineCare;
                                    _subCategory = 'Feminine Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Electric Shavers'),
                                value: _healthHousehold ==
                                    HealthHousehold.electricShavers,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.electricShavers;
                                    _subCategory = 'Electric Shavers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Razors & Blades'),
                                value: _healthHousehold ==
                                    HealthHousehold.razorsAndBlades,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.razorsAndBlades;
                                    _subCategory = 'Razors and Blades';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bath & Body'),
                                value: _healthHousehold ==
                                    HealthHousehold.bathAndBody,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.bathAndBody;
                                    _subCategory = 'Bath and Body';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Weight Management'),
                                value: _healthHousehold ==
                                    HealthHousehold.weightManagement,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.weightManagement;
                                    _subCategory = 'Weight Management';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Proteins & Fitness'),
                                value: _healthHousehold ==
                                    HealthHousehold.proteinsAndFitness,
                                onChanged: (value) {
                                  setState(() {
                                    _healthHousehold =
                                        HealthHousehold.proteinsAndFitness;
                                    _subCategory = 'Proteins and Fitness';
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
