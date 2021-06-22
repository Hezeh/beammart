import 'package:beammart/enums/home_kitchen.dart';
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
                              label: Text('Kitchen & Dining'),
                              selectedColor: Colors.pink,
                              selected:
                                  _homeKitchen == HomeKitchen.kitchenAndDining,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.kitchenAndDining;
                                  _subCategory = 'Kitchen and Dining';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Bedding'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.bedding,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.bedding;
                                  _subCategory = 'Bedding';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Bath'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.bath,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.bath;
                                  _subCategory = 'Bath';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Furniture'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.furniture,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.furniture;
                                  _subCategory = 'Furniture';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Appliances'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.appliances,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.appliances;
                                  _subCategory = 'Appliances';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Mattresses'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.mattresses,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.mattresses;
                                  _subCategory = 'Mattresses';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Rugs'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.rugs,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.rugs;
                                  _subCategory = 'Rugs';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Curtains'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.curtains,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.curtains;
                                  _subCategory = 'Curtains';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Blinds & Shades'),
                              selectedColor: Colors.pink,
                              selected:
                                  _homeKitchen == HomeKitchen.blindsAndShades,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.blindsAndShades;
                                  _subCategory = 'Blinds and Shades';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Wall Art'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.wallArt,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.wallArt;
                                  _subCategory = 'Wall Art';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Wall Decor'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.wallDecor,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.wallDecor;
                                  _subCategory = 'Wall Decor';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Candles & Home Fragrance'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.candlesAndHomeFragrance,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.candlesAndHomeFragrance;
                                  _subCategory = 'Candles and Home Fragrance';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Home Decor'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen == HomeKitchen.homeDecor,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.homeDecor;
                                  _subCategory = 'Home Decor';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Lighting & Ceiling Fans'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.lightingAndCeilingFans,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.lightingAndCeilingFans;
                                  _subCategory = 'Lighting and Ceiling Fans';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Seasonal Decor'),
                              selectedColor: Colors.pink,
                              selected:
                                  _homeKitchen == HomeKitchen.seasonalDecor,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.seasonalDecor;
                                  _subCategory = 'Seasonal Decor';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Event & Party Supplies'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.eventAndPartySupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.eventAndPartySupplies;
                                  _subCategory = 'Event and Party Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Heating, Cooling & Air Quality'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.heatingCoolingAndAirQuality,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.heatingCoolingAndAirQuality;
                                  _subCategory =
                                      'Heating, Cooling and Air Quality';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Iron & Steamers'),
                              selectedColor: Colors.pink,
                              selected:
                                  _homeKitchen == HomeKitchen.ironsAndSteamers,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.ironsAndSteamers;
                                  _subCategory = 'Iron and Steamers';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Vacuums & Floor Care'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.vacuumsAndFloorCare,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.vacuumsAndFloorCare;
                                  _subCategory = 'Vacuums and Floor Care';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Storage & Organization'),
                              selectedColor: Colors.pink,
                              selected: _homeKitchen ==
                                  HomeKitchen.storageAndOrganization,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen =
                                      HomeKitchen.storageAndOrganization;
                                  _subCategory = 'Storage and Organization';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Cleaning Supplies'),
                              selectedColor: Colors.pink,
                              selected:
                                  _homeKitchen == HomeKitchen.cleaningSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _homeKitchen = HomeKitchen.cleaningSupplies;
                                  _subCategory = 'Cleaning Supplies';
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
