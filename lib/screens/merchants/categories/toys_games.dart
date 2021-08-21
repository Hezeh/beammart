import 'package:beammart/enums/toys_games.dart';
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

class ToysGamesScreen extends StatefulWidget {
  @override
  _ToysGamesScreenState createState() => _ToysGamesScreenState();
}

class _ToysGamesScreenState extends State<ToysGamesScreen> {
  ToysGames _toysGames = ToysGames.actionFiguresAndStatues;

  bool isExpanded = true;

  final _toysGamesFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Toys and Games';

  String _subCategory = 'Action Figures and Statues';

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
      if (_toysGamesFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.toysGamesTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.toysGamesTokens!;
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
              title: Text('Toys & Games'),
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
              key: _toysGamesFormKey,
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
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text('Subcategories'),
                          );
                        },
                        body: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Action Figures & Statues'),
                              value: _toysGames ==
                                  ToysGames.actionFiguresAndStatues,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.actionFiguresAndStatues;
                                  _subCategory = 'Action Figures and Statues';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Baby & Toddler Toys'),
                              value: _toysGames == ToysGames.babyToddlerToys,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.babyToddlerToys;
                                  _subCategory = 'Baby and Toddler Toys';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Building Toys'),
                              value: _toysGames == ToysGames.buildingToys,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.buildingToys;
                                  _subCategory = 'Building Toys';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Dolls & Accessories'),
                              value:
                                  _toysGames == ToysGames.dollsAndAccessories,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.dollsAndAccessories;
                                  _subCategory = 'Dolls and Accessories';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Dress Up & Pretend Play'),
                              value:
                                  _toysGames == ToysGames.dressUpAndPretendPlay,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.dressUpAndPretendPlay;
                                  _subCategory = 'Dress Up and Pretend Play';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text("Kids' Electronics"),
                              value: _toysGames == ToysGames.kidsElectronics,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.kidsElectronics;
                                  _subCategory = "Kids' Electronics";
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Games'),
                              value: _toysGames == ToysGames.games,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.games;
                                  _subCategory = 'Games';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Grown Up Toys'),
                              value: _toysGames == ToysGames.grownupToys,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.grownupToys;
                                  _subCategory = 'Grown Up Toys';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Hobbies'),
                              value: _toysGames == ToysGames.hobbies,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.hobbies;
                                  _subCategory = 'Hobbies';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text("Kids' Furniture, Decor & Storage"),
                              value: _toysGames ==
                                  ToysGames.kidsFurnitureDecorAndStorage,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.kidsFurnitureDecorAndStorage;
                                  _subCategory =
                                      "Kids' Furniture, Decor and Storage";
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Learning & Education'),
                              value:
                                  _toysGames == ToysGames.learningAndEducation,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.learningAndEducation;
                                  _subCategory = 'Learning and Education';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Novelty & Gag Toys'),
                              value: _toysGames == ToysGames.noveltyAndGagToys,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.noveltyAndGagToys;
                                  _subCategory = 'Novelty and Gag Toys';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Party Supplies'),
                              value: _toysGames == ToysGames.partySupplies,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.partySupplies;
                                  _subCategory = 'Party Supplies';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Puzzles'),
                              value: _toysGames == ToysGames.puzzles,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.puzzles;
                                  _subCategory = 'Puzzles';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Sports & Outdoor Play'),
                              value:
                                  _toysGames == ToysGames.sportsAndOutdoorPlay,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames = ToysGames.sportsAndOutdoorPlay;
                                  _subCategory = 'Sports and Outdoor Play';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Stuffed Animals & Plush Toys'),
                              value: _toysGames ==
                                  ToysGames.stuffedAnimalsAndPlushToys,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.stuffedAnimalsAndPlushToys;
                                  _subCategory =
                                      'Stuffed Animals and Plush Toys';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Toy Remote Control & Play Vehicles'),
                              value: _toysGames ==
                                  ToysGames.toyRemoteControlAndPlayVehicles,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.toyRemoteControlAndPlayVehicles;
                                  _subCategory =
                                      'Toy Remote Control and Play Vehicles';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Tricycles, Scooters & Wagons'),
                              value: _toysGames ==
                                  ToysGames.tricylesScootersAndWagons,
                              onChanged: (value) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.tricylesScootersAndWagons;
                                  _subCategory =
                                      'Tricycles, Scooters and Wagons';
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
