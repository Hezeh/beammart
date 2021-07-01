import 'package:beammart/enums/home_entertainment_furniture.dart';
import 'package:beammart/enums/kitchen_and_table_linens.dart';
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

class KitchenAndTableLinensScreen extends StatefulWidget {
  const KitchenAndTableLinensScreen({Key? key}) : super(key: key);

  @override
  _KitchenAndTableLinensScreenState createState() =>
      _KitchenAndTableLinensScreenState();
}

class _KitchenAndTableLinensScreenState
    extends State<KitchenAndTableLinensScreen> {
  KitchenAndTableLinens _kitchenAndTableLinens = KitchenAndTableLinens.aprons;

  bool isExpanded = true;

  final _kitchenAndTableLinensFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Kitchen and Table Linens';

  String _subCategory = 'Aprons';

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
      if (_kitchenAndTableLinensFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider
                    .categoryTokens!.kitchenAndTableLinensTokens !=
                null) {
          final double requiredTokens = _categoryTokensProvider
              .categoryTokens!.kitchenAndTableLinensTokens!;
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
              title: Text('Kitchen And Table Linens'),
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
              key: _kitchenAndTableLinensFormKey,
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
                            title: Text(
                                'Kitchen & Table Linens Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Aprons'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.aprons,
                                onChanged: (value) {
                                  setState(() {
                                   _kitchenAndTableLinens =
                                        KitchenAndTableLinens.aprons;
                                    _subCategory = 'Aprons';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Table Linens'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.tableLinens,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.tableLinens;
                                    _subCategory = 'Table Linens';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Table Runners'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.tableRunners,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.tableRunners;
                                    _subCategory = 'Table Runners';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fabric Table Cloths'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.fabricTablecloths,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.fabricTablecloths;
                                    _subCategory = 'Fabric Table Cloths';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Round Table Cloths'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.roundTablecloths,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.roundTablecloths;
                                    _subCategory = 'Round Table Cloths';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Outdoor Table Cloths'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.outdoorTablecloths,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.outdoorTablecloths;
                                    _subCategory = 'Outdoor Table Cloths';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Vinyl Table Cloths'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.vinylTablecloths,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.vinylTablecloths;
                                    _subCategory = 'Vinyl Table Cloths';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Chair Pads and Chair Cushions'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.chairPadsAndChairCushions,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.chairPadsAndChairCushions;
                                    _subCategory = 'Chair Pads and Chair Cushions';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kitchen Towels'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.kitchenTowels,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.kitchenTowels;
                                    _subCategory = 'Kitchen Towels';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Dish Cloths'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.dishCloths,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.dishCloths;
                                    _subCategory = 'Dish Cloths';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Oven Gloves'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.ovenGloves,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.ovenGloves;
                                    _subCategory = 'Oven Gloves';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Table Skirts'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.tableSkirts,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.tableSkirts;
                                    _subCategory = 'Table Skirts';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Serverware'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.serverware,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.serverware;
                                    _subCategory = 'Serverware';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Holders'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.holders,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.holders;
                                    _subCategory = 'Holders';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Oven Mitts and Pot'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.ovenMittsAndPot,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.ovenMittsAndPot;
                                    _subCategory = 'Oven Mitts and Pot';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Placemat'),
                                value: _kitchenAndTableLinens ==
                                    KitchenAndTableLinens.placemat,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAndTableLinens =
                                        KitchenAndTableLinens.placemat;
                                    _subCategory = 'Placemat';
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
