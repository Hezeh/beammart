import 'package:beammart/enums/patio_garden.dart';
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

class PatioGardenScreen extends StatefulWidget {
  @override
  _PatioGardenScreenState createState() => _PatioGardenScreenState();
}

class _PatioGardenScreenState extends State<PatioGardenScreen> {
  PatioGarden _patioGarden = PatioGarden.garden;

  bool isExpanded = true;

  final _patioGardenFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Patio and Garden';

  String _subCategory = 'Garden';

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
      if (_patioGardenFormKey.currentState!.validate()) {
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
              title: Text('Patio & Garden'),
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
              key: _patioGardenFormKey,
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
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text('Patio & Garden Subcategories'),
                          );
                        },
                        body: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Garden'),
                              value: _patioGarden == PatioGarden.garden,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.garden;
                                  _subCategory = 'Garden';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Patio Furniture'),
                              value: _patioGarden == PatioGarden.patioFurniture,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.patioFurniture;
                                  _subCategory = 'Patio Furniture';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Grills & Outdoor Cooking'),
                              value: _patioGarden ==
                                  PatioGarden.grillsAndOutdoorCooking,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden =
                                      PatioGarden.grillsAndOutdoorCooking;
                                  _subCategory = 'Grills and Outdoor Cooking';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Outdoor Decor'),
                              value: _patioGarden == PatioGarden.outdoorDecor,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.outdoorDecor;
                                  _subCategory = 'Outdoor Decor';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Sheds & Outdoor Storage'),
                              value: _patioGarden ==
                                  PatioGarden.shedsAndOutdoorStorage,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden =
                                      PatioGarden.shedsAndOutdoorStorage;
                                  _subCategory = 'Sheds and Outdoor Storage';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Outdoor Heating'),
                              value: _patioGarden == PatioGarden.outdoorHeating,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.outdoorHeating;
                                  _subCategory = 'Outdoor Heating';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Outdoor Shade'),
                              value: _patioGarden == PatioGarden.outdoorShade,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.outdoorShade;
                                  _subCategory = 'Outdoor Shade';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Outdoor Lighting'),
                              value:
                                  _patioGarden == PatioGarden.outdoorLighting,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden = PatioGarden.outdoorLighting;
                                  _subCategory = 'Outdoor Lighting';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Plants, Flowers & Trees'),
                              value: _patioGarden ==
                                  PatioGarden.plantsFlowersAndTrees,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden =
                                      PatioGarden.plantsFlowersAndTrees;
                                  _subCategory = 'Plants, Flowers and Trees';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Outdoor Power Equipment'),
                              value: _patioGarden ==
                                  PatioGarden.outdoorPowerEquipment,
                              onChanged: (value) {
                                setState(() {
                                  _patioGarden =
                                      PatioGarden.outdoorPowerEquipment;
                                  _subCategory = 'Outdoor Power Equipment';
                                });
                              },
                            ),
                          ],
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
