import 'package:beammart/enums/home_entertainment_furniture.dart';
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

class HomeEntertainmentFurnitureScreen extends StatefulWidget {
  const HomeEntertainmentFurnitureScreen({Key? key}) : super(key: key);

  @override
  _HomeEntertainmentFurnitureScreenState createState() =>
      _HomeEntertainmentFurnitureScreenState();
}

class _HomeEntertainmentFurnitureScreenState
    extends State<HomeEntertainmentFurnitureScreen> {
  HomeEntertainmentFurniture _homeEntertainmentFurniture =
      HomeEntertainmentFurniture.audioAndMediaTowers;

  bool isExpanded = true;

  final _homeEntertainmentFurnitureFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Home Entertainment Furniture';

  String _subCategory = 'Audio and Media Towers';

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
      if (_homeEntertainmentFurnitureFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider
                    .categoryTokens!.homeEntertainmentFurnitureTokens !=
                null) {
          final double requiredTokens = _categoryTokensProvider
              .categoryTokens!.homeEntertainmentFurnitureTokens!;
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
              title: Text('Home Entertainment Furniture'),
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
              key: _homeEntertainmentFurnitureFormKey,
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
                            title: Text(
                                'Home Entertainment Furniture Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Audio and Media Towers'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture
                                        .audioAndMediaTowers,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture
                                            .audioAndMediaTowers;
                                    _subCategory = 'Audio and Media Towers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('TV Stands'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.tvStands,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture.tvStands;
                                    _subCategory = 'TV Stands';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Entertainment Centers'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture
                                        .entertainmentCenters,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture
                                            .entertainmentCenters;
                                    _subCategory = 'Entertainment Centers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fireplace TV Stands'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture
                                        .fireplaceTvStands,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture
                                            .fireplaceTvStands;
                                    _subCategory = 'Fireplace TV Stands';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Corner Stands'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.cornerStands,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture.cornerStands;
                                    _subCategory = 'Corner Stands';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Speaker Stands'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.speakerStands,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture
                                            .speakerStands;
                                    _subCategory = 'Speaker Stands';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('CD and DVD Storage'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.cdAndDVDStorage,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture
                                            .cdAndDVDStorage;
                                    _subCategory = 'CD and DVD Storage';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Gaming Chairs'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.gamingChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture.gamingChairs;
                                    _subCategory = 'Gaming Chairs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Gaming Stands'),
                                value: _homeEntertainmentFurniture ==
                                    HomeEntertainmentFurniture.gamingStands,
                                onChanged: (value) {
                                  setState(() {
                                    _homeEntertainmentFurniture =
                                        HomeEntertainmentFurniture.gamingStands;
                                    _subCategory = 'Gaming Stands';
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
