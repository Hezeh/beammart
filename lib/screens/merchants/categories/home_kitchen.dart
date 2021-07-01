import 'package:beammart/enums/home_kitchen.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/posting_item_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tokens_screen.dart';

class HomeKitchenScreen extends StatefulWidget {
  @override
  _HomeKitchenScreenState createState() => _HomeKitchenScreenState();
}

class _HomeKitchenScreenState extends State<HomeKitchenScreen> {
  HomeKitchen _homeKitchen = HomeKitchen.kitchenAndDining;

  bool isExpanded = true;

  final _homeKitchenFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Home and Kitchen';

  String _subCategory = 'Kitchen and Dining';

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
      if (_homeKitchenFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.homeKitchenTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.homeKitchenTokens!;
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
              title: Text('Home & Kitchen'),
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
              key: _homeKitchenFormKey,
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
                    expansionCallback: (int index, bool _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Home Kitchen Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Kitchen & Dining'),
                                value: _homeKitchen ==
                                    HomeKitchen.kitchenAndDining,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.kitchenAndDining;
                                    _subCategory = 'Kitchen and Dining';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bedding'),
                                value: _homeKitchen == HomeKitchen.bedding,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.bedding;
                                    _subCategory = 'Bedding';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bath'),
                                value: _homeKitchen == HomeKitchen.bath,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.bath;
                                    _subCategory = 'Bath';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Furniture'),
                                value: _homeKitchen == HomeKitchen.furniture,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.furniture;
                                    _subCategory = 'Furniture';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Appliances'),
                                value: _homeKitchen == HomeKitchen.appliances,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.appliances;
                                    _subCategory = 'Appliances';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Mattresses'),
                                value: _homeKitchen == HomeKitchen.mattresses,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.mattresses;
                                    _subCategory = 'Mattresses';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Rugs'),
                                value: _homeKitchen == HomeKitchen.rugs,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.rugs;
                                    _subCategory = 'Rugs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Curtains'),
                                value: _homeKitchen == HomeKitchen.curtains,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.curtains;
                                    _subCategory = 'Curtains';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Wall Art'),
                                value: _homeKitchen == HomeKitchen.wallArt,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.wallArt;
                                    _subCategory = 'Wall Art';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Wall Decor'),
                                value: _homeKitchen == HomeKitchen.wallDecor,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.wallDecor;
                                    _subCategory = 'Wall Decor';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Candles & Home Fragrance'),
                                value: _homeKitchen ==
                                    HomeKitchen.candlesAndHomeFragrance,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.candlesAndHomeFragrance;
                                    _subCategory = 'Candles and Home Fragrance';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Home Decor'),
                                value: _homeKitchen == HomeKitchen.homeDecor,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.homeDecor;
                                    _subCategory = 'Home Decor';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Lighting & Ceiling Fans'),
                                value: _homeKitchen ==
                                    HomeKitchen.lightingAndCeilingFans,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.lightingAndCeilingFans;
                                    _subCategory = 'Lighting and Ceiling Fans';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Seasonal Decor'),
                                value:
                                    _homeKitchen == HomeKitchen.seasonalDecor,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.seasonalDecor;
                                    _subCategory = 'Seasonal Decor';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Event & Party Supplies'),
                                value: _homeKitchen ==
                                    HomeKitchen.eventAndPartySupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.eventAndPartySupplies;
                                    _subCategory = 'Event and Party Supplies';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Heating, Cooling & Air Quality'),
                                value: _homeKitchen ==
                                    HomeKitchen.heatingCoolingAndAirQuality,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.heatingCoolingAndAirQuality;
                                    _subCategory =
                                        'Heating, Cooling and Air Quality';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Iron & Steamers'),
                                value: _homeKitchen ==
                                    HomeKitchen.ironsAndSteamers,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.ironsAndSteamers;
                                    _subCategory = 'Iron and Steamers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Vacuums & Floor Care'),
                                value: _homeKitchen ==
                                    HomeKitchen.vacuumsAndFloorCare,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.vacuumsAndFloorCare;
                                    _subCategory = 'Vacuums and Floor Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Storage & Organization'),
                                value: _homeKitchen ==
                                    HomeKitchen.storageAndOrganization,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen =
                                        HomeKitchen.storageAndOrganization;
                                    _subCategory = 'Storage and Organization';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cleaning Supplies'),
                                value: _homeKitchen ==
                                    HomeKitchen.cleaningSupplies,
                                onChanged: (value) {
                                  setState(() {
                                    _homeKitchen = HomeKitchen.cleaningSupplies;
                                    _subCategory = 'Cleaning Supplies';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        isExpanded: isExpanded,
                      )
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
