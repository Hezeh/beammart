import 'package:beammart/enums/kitchen_tools_and_gadgets.dart';
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

class KitchenToolsAndGadgetsScreen extends StatefulWidget {
  const KitchenToolsAndGadgetsScreen({Key? key}) : super(key: key);

  @override
  _KitchenToolsAndGadgetsScreenState createState() =>
      _KitchenToolsAndGadgetsScreenState();
}

class _KitchenToolsAndGadgetsScreenState
    extends State<KitchenToolsAndGadgetsScreen> {
  KitchenToolsAndGadgets _kitchenToolsAndGadgets =
      KitchenToolsAndGadgets.colandersAndStrainers;

  bool isExpanded = true;

  final _kitchenToolsAndGadgetsFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Kitchen Tools and Gadgets';

  String _subCategory = 'Colander and Strainers';

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
      if (_kitchenToolsAndGadgetsFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider
                    .categoryTokens!.kitchenToolsAndGadgetsTokens !=
                null) {
          final double requiredTokens = _categoryTokensProvider
              .categoryTokens!.kitchenToolsAndGadgetsTokens!;
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
              title: Text('Kitchen Tools & Gadgets'),
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
              key: _kitchenToolsAndGadgetsFormKey,
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
                            title:
                                Text('Kitchen Tools & Gadgets Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Colanders and Strainers'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets
                                        .colandersAndStrainers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets
                                            .colandersAndStrainers;
                                    _subCategory = 'Colanders and Strainers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kitchen Tools and Utensil Sets'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets
                                        .kitchenToolsAndUtensilSets,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets
                                            .kitchenToolsAndUtensilSets;
                                    _subCategory =
                                        'Kitchen Tools and Utensil Sets';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cutlery'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.cutlery,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.cutlery;
                                    _subCategory = 'Cutlery';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Meat Thermometers'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.meatThermometers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.meatThermometers;
                                    _subCategory = 'Meat Thermometers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Spatulas and Turners'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.spatulasAndTurners,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets
                                            .spatulasAndTurners;
                                    _subCategory = 'Spatulas and Turners';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cooking Spoons'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.cookingSpoons,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.cookingSpoons;
                                    _subCategory = 'Cooking Spoons';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Tongs'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.tongs,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.tongs;
                                    _subCategory = 'Tongs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Mixing Bowls'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.mixingBowls,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.mixingBowls;
                                    _subCategory = 'Mixing Bowls';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kitchen Scales'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.kitchenScales,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets.kitchenScales;
                                    _subCategory = 'Kitchen Scales';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Graters and Zesters'),
                                value: _kitchenToolsAndGadgets ==
                                    KitchenToolsAndGadgets.gratersAndZesters,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenToolsAndGadgets =
                                        KitchenToolsAndGadgets
                                            .gratersAndZesters;
                                    _subCategory = 'Graters and Zesters';
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
