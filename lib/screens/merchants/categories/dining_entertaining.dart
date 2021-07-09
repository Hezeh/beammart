import 'package:beammart/enums/dining_entertaining.dart';
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

class DiningAndEntertainingScreen extends StatefulWidget {
  const DiningAndEntertainingScreen({Key? key}) : super(key: key);

  @override
  _DiningAndEntertainingScreenState createState() =>
      _DiningAndEntertainingScreenState();
}

class _DiningAndEntertainingScreenState
    extends State<DiningAndEntertainingScreen> {
  DiningAndEntertaining _diningAndEntertaining =
      DiningAndEntertaining.dinnerwareSets;

  bool isExpanded = true;

  final _diningAndEntertainingFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Dining and Entertaining';

  String _subCategory = 'Dinnerware Sets';

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
      if (_diningAndEntertainingFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.diningEntertainingTokens !=
                null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.diningEntertainingTokens!;
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
              title: Text('Dining & Entertaining'),
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
              key: _diningAndEntertainingFormKey,
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
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Dining & Entertaining Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Dinnerware Sets'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.dinnerwareSets,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.dinnerwareSets;
                                    _subCategory = 'Dinnerware Sets';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Barware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.barware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.barware;
                                    _subCategory = 'Barware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Flatware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.flatware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.flatware;
                                    _subCategory = 'Flatware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Glassware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.glassware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.glassware;
                                    _subCategory = 'Glassware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Mugs'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.mugs,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.mugs;
                                    _subCategory = 'Mugs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Plates'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.plates,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.plates;
                                    _subCategory = 'Plates';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bowls'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.bowls,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.bowls;
                                    _subCategory = 'Bowls';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Serverware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.serverware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.serverware;
                                    _subCategory = 'Serverware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Outdoor Dinnerware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.outdoorDinnerware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.outdoorDinnerware;
                                    _subCategory = 'Outdoor Dinnerware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Beverage Dispensers'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.beverageDispensers,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining
                                            .beverageDispensers;
                                    _subCategory = 'Beverage Dispensers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kids Tableware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.kidsTableware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.kidsTableware;
                                    _subCategory = 'Kids Tableware';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kitchen Textiles'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.kitchenTextiles,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.kitchenTextiles;
                                    _subCategory = 'Kitchen Textiles';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Travel Mugs'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.travelMugs,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.travelMugs;
                                    _subCategory = 'Travel Mugs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Salt and Pepper Shakers'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.saltAndPepperShakers,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining
                                            .saltAndPepperShakers;
                                    _subCategory = 'Salt and Pepper Shakers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Barware'),
                                value: _diningAndEntertaining ==
                                    DiningAndEntertaining.barware,
                                onChanged: (value) {
                                  setState(() {
                                    _diningAndEntertaining =
                                        DiningAndEntertaining.barware;
                                    _subCategory = 'Barware';
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
