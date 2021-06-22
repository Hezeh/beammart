import 'package:beammart/enums/toys_games.dart';
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

  String _subCategory = '';

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
      if (_toysGamesFormKey.currentState!.validate()) {
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
                              label: Text('Action Figures & Statues'),
                              selectedColor: Colors.pink,
                              selected: _toysGames ==
                                  ToysGames.actionFiguresAndStatues,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.actionFiguresAndStatues;
                                  _subCategory = 'Action Figures and Statues';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Baby & Toddler Toys'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.babyToddlerToys,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.babyToddlerToys;
                                  _subCategory = 'Baby and Toddler Toys';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Building Toys'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.buildingToys,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.buildingToys;
                                  _subCategory = 'Building Toys';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Dolls & Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _toysGames == ToysGames.dollsAndAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.dollsAndAccessories;
                                  _subCategory = 'Dolls and Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Dress Up & Pretend Play'),
                              selectedColor: Colors.pink,
                              selected:
                                  _toysGames == ToysGames.dressUpAndPretendPlay,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.dressUpAndPretendPlay;
                                  _subCategory = 'Dress Up and Pretend Play';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text("Kids' Electronics"),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.kidsElectronics,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.kidsElectronics;
                                  _subCategory = "Kids' Electronics";
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Games'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.games,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.games;
                                  _subCategory = 'Games';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Grown Up Toys'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.grownupToys,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.grownupToys;
                                  _subCategory = 'Grown Up Toys';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Hobbies'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.hobbies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.hobbies;
                                  _subCategory = 'Hobbies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text("Kids' Furniture, Decor & Storage"),
                              selectedColor: Colors.pink,
                              selected: _toysGames ==
                                  ToysGames.kidsFurnitureDecorAndStorage,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.kidsFurnitureDecorAndStorage;
                                  _subCategory =
                                      "Kids' Furniture, Decor and Storage";
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Learning & Education'),
                              selectedColor: Colors.pink,
                              selected:
                                  _toysGames == ToysGames.learningAndEducation,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.learningAndEducation;
                                  _subCategory = 'Learning and Education';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Novelty & Gag Toys'),
                              selectedColor: Colors.pink,
                              selected:
                                  _toysGames == ToysGames.noveltyAndGagToys,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.noveltyAndGagToys;
                                  _subCategory = 'Novelty and Gag Toys';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Party Supplies'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.partySupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.partySupplies;
                                  _subCategory = 'Party Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Puzzles'),
                              selectedColor: Colors.pink,
                              selected: _toysGames == ToysGames.puzzles,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.puzzles;
                                  _subCategory = 'Puzzles';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Sports & Outdoor Play'),
                              selectedColor: Colors.pink,
                              selected:
                                  _toysGames == ToysGames.sportsAndOutdoorPlay,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames = ToysGames.sportsAndOutdoorPlay;
                                  _subCategory = 'Sports and Outdoor Play';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Stuffed Animals & Plush Toys'),
                              selectedColor: Colors.pink,
                              selected: _toysGames ==
                                  ToysGames.stuffedAnimalsAndPlushToys,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.stuffedAnimalsAndPlushToys;
                                  _subCategory =
                                      'Stuffed Animals and Plush Toys';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Toy Remote Control & Play Vehicles'),
                              selectedColor: Colors.pink,
                              selected: _toysGames ==
                                  ToysGames.toyRemoteControlAndPlayVehicles,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toysGames =
                                      ToysGames.toyRemoteControlAndPlayVehicles;
                                  _subCategory =
                                      'Toy Remote Control and Play Vehicles';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Tricycles, Scooters & Wagons'),
                              selectedColor: Colors.pink,
                              selected: _toysGames ==
                                  ToysGames.tricylesScootersAndWagons,
                              onSelected: (bool selected) {
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
