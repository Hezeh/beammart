import 'package:beammart/enums/luggage.dart';
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

class LuggageScreen extends StatefulWidget {
  @override
  _LuggageScreenState createState() => _LuggageScreenState();
}

class _LuggageScreenState extends State<LuggageScreen> {
  Luggage _luggage = Luggage.backpacks;

  final _luggageFormKey = GlobalKey<FormState>();

  bool isExpanded = true;

  bool _loading = false;

  final String _category = 'Luggage';

  String _subCategory = 'Backpacks';

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
      if (_luggageFormKey.currentState!.validate()) {
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
              title: Text('Luggage'),
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
              key: _luggageFormKey,
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
                            title: Text('Luggage Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Backpacks'),
                              selected: _luggage == Luggage.backpacks,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.backpacks;
                                  _subCategory = 'Backpacks';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Carryons'),
                              selected: _luggage == Luggage.carryons,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.carryons;
                                  _subCategory = 'Carryons';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Garment Bags'),
                              selected: _luggage == Luggage.garmentBags,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.garmentBags;
                                  _subCategory = 'Garment Bags';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Travel Totes'),
                              selected: _luggage == Luggage.travelTotes,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.travelTotes;
                                  _subCategory = 'Travel Totes';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Luggage Sets'),
                              selected: _luggage == Luggage.luggageSets,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.luggageSets;
                                  _subCategory = 'Luggage Sets';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Laptop Bags'),
                              selected: _luggage == Luggage.laptopBags,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.laptopBags;
                                  _subCategory = 'Laptop Bags';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Suitcases'),
                              selected: _luggage == Luggage.suitcases,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.suitcases;
                                  _subCategory = 'Suitcases';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text("Kids' Luggage"),
                              selected: _luggage == Luggage.kidsLuggage,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.kidsLuggage;
                                  _subCategory = "Kids' Luggage";
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Messenger Bags'),
                              selected: _luggage == Luggage.messengerBags,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.messengerBags;
                                  _subCategory = 'Messenger Bags';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Umbrellas'),
                              selected: _luggage == Luggage.umbrellas,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.umbrellas;
                                  _subCategory = 'Umbrellas';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Duffles'),
                              selected: _luggage == Luggage.duffles,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.duffles;
                                  _subCategory = 'Duffles';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Travel Accessories'),
                              selected: _luggage == Luggage.travelAccessories,
                              selectedColor: Colors.pink,
                              onSelected: (bool selected) {
                                setState(() {
                                  _luggage = Luggage.travelAccessories;
                                  _subCategory = 'Travel Accessories';
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
