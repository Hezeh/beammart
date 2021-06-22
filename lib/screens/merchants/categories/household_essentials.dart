import 'package:beammart/enums/household_essentials.dart';
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

class HouseholdEssentialsScreen extends StatefulWidget {
  @override
  _HouseholdEssentialsScreenState createState() =>
      _HouseholdEssentialsScreenState();
}

class _HouseholdEssentialsScreenState extends State<HouseholdEssentialsScreen> {
  HouseholdEssentials _householdEssentials = HouseholdEssentials.laundryRoom;

  bool isExpanded = true;

  final _householdEssentialsFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Household Essentials';

  String _subCategory = 'Laundry Room';

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
      if (_householdEssentialsFormKey.currentState!.validate()) {
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
              title: Text('Household Essentials'),
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
              key: _householdEssentialsFormKey,
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
                            title: Text('Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Laundry Room'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.laundryRoom,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.laundryRoom;
                                  _subCategory = 'Laundry Room';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Kitchen'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.kitchen,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.kitchen;
                                  _subCategory = 'Kitchen';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Bathroom'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.bathroom,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.bathroom;
                                  _subCategory = 'Bathroom';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Paper & Plastic'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.paperAndPlastic,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.paperAndPlastic;
                                  _subCategory = 'Paper and Plastic';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Cleaning Supplies'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.cleaningSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.cleaningSupplies;
                                  _subCategory = 'Cleaning Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Air Fresheners'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.airFresheners,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.airFresheners;
                                  _subCategory = 'Air Freshners';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Batteries'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.batteries,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.batteries;
                                  _subCategory = 'Batteries';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Pest Control'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.pestControl,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.pestControl;
                                  _subCategory = 'Pest Control';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Light Bulbs'),
                              selectedColor: Colors.pink,
                              selected: _householdEssentials ==
                                  HouseholdEssentials.lightBulbs,
                              onSelected: (bool selected) {
                                setState(() {
                                  _householdEssentials =
                                      HouseholdEssentials.lightBulbs;
                                  _subCategory = 'Light Bulbs';
                                });
                              },
                            ),
                          ],
                        ),
                        isExpanded: isExpanded,
                      ),
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
