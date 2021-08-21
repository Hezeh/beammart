import 'package:beammart/enums/kitchen_appliances.dart';
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

class KitchenAppliancesScreen extends StatefulWidget {
  const KitchenAppliancesScreen({Key? key}) : super(key: key);

  @override
  _KitchenAppliancesScreenState createState() =>
      _KitchenAppliancesScreenState();
}

class _KitchenAppliancesScreenState extends State<KitchenAppliancesScreen> {
  KitchenAppliances _kitchenAppliances = KitchenAppliances.microWaves;

  bool isExpanded = true;

  final _kitchenAppliancesFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Kitchen Appliances';

  String _subCategory = 'Microwaves';

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
      if (_kitchenAppliancesFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.kitchenAppliancesTokens !=
                null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.kitchenAppliancesTokens!;
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
              title: Text('Kitchen Appliances'),
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
              key: _kitchenAppliancesFormKey,
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
                            title: Text('Kitchen Appliances'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Air Fryers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.airFryers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.airFryers;
                                    _subCategory = 'Air Fryers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Microwaves'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.microWaves,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.microWaves;
                                    _subCategory = 'Microwaves';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Coffee Makers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.coffeeMakers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.coffeeMakers;
                                    _subCategory = 'Coffee Makers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Mixers & Attachments'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.mixersAndAttachments,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.mixersAndAttachments;
                                    _subCategory = 'Mixers and Attachments';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Pressure Cookers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.pressureCookers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.pressureCookers;
                                    _subCategory = 'Pressure Cookers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Blenders'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.blenders,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.blenders;
                                    _subCategory = 'Blenders';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Indoor Grills'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.indoorGrills,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.indoorGrills;
                                    _subCategory = 'Indoor Grills';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Toasters & Toaster Ovens'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.toastersAndToasterOvens,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances = KitchenAppliances
                                        .toastersAndToasterOvens;
                                    _subCategory = 'Toasters and Toaster Ovens';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Soda Makers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.sodaMakers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.sodaMakers;
                                    _subCategory = 'Soda Makers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Juicers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.juicers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.juicers;
                                    _subCategory = 'Juicers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Slow Cookers'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.slowCookers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.slowCookers;
                                    _subCategory = 'Slow Cookers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Food Processors'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.slowCookers,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.slowCookers;
                                    _subCategory = 'Food Processors';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Food Processors'),
                                value: _kitchenAppliances ==
                                    KitchenAppliances.foodProcessors,
                                onChanged: (value) {
                                  setState(() {
                                    _kitchenAppliances =
                                        KitchenAppliances.foodProcessors;
                                    _subCategory = 'Food Processors';
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
